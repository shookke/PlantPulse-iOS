//
//  HomeViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/24/24.
//

import Foundation
import Combine
import CoreLocation

enum WeatherViewState {
    case idle
    case loading
    case data(WeatherResponse)
    case error(String)
}

class HomeViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var areas: [Area] = []
    @Published var areaPlants: [Area: [Plant]] = [:]
    @Published var plantsLoadError: String? = nil
    @Published var weatherViewState: WeatherViewState = .idle

    // Managers
    let locationManager: LocationManager
    let weatherManager: WeatherManager

    // Combine cancellables
    private var cancellables = Set<AnyCancellable>()

    // Initialization
    init(locationManager: LocationManager = LocationManager(),
         weatherManager: WeatherManager = WeatherManager()) {
        self.locationManager = locationManager
        self.weatherManager = weatherManager

        // Observe location updates
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                Task {
                    await self?.fetchWeather(for: location)
                }
            }
            .store(in: &cancellables)

        // Observe authorization status changes
        locationManager.$authorizationStatus
            .sink { [weak self] status in
                self?.handleAuthorizationStatus(status)
            }
            .store(in: &cancellables)

        // Load initial data
        loadData()
    }

    // Load initial data
    func loadData() {
        Task {
            await fetchAreas()
            await fetchPlants()
        }
        //requestLocationAndFetchWeather()
    }

    // Fetch Areas
    @MainActor
    func fetchAreas() async {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/areas/") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            let decoder = JSONDecoder()
            let areasResponse = try decoder.decode(AreasResponse.self, from: data)
            
            self.areas = areasResponse.areas
            groupPlantsByArea()
        } catch {
            plantsLoadError = error.localizedDescription
        }
    }

    // Fetch Plants
    @MainActor
    func fetchPlants() async {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            let decoder = JSONDecoder()
            let plantsResponse = try decoder.decode(PlantsResponse.self, from: data)
            
            self.plants = plantsResponse.plants
            groupPlantsByArea()
        } catch {
            plantsLoadError = error.localizedDescription
        }
    }

    // Group Plants by Area
    @MainActor
    func groupPlantsByArea() {
        var areaSet = Set<Area>()
        var dict = [Area: [Plant]]()

        for plant in plants {
            let area = plant.area ?? Area.noArea
            areaSet.insert(area)
            dict[area, default: []].append(plant)
        }

        self.areas = Array(areaSet).sorted { $0.name < $1.name }
        self.areaPlants = dict
    }

    // MARK: - Weather Data Handling
    
    private func requestLocationAndFetchWeather() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestLocation()
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = locationManager.location {
                Task {
                    await self.fetchWeather(for: location)
                }
            } else {
                locationManager.requestLocation()
            }
        case .denied, .restricted:
            weatherViewState = .error("Location access denied. Please enable location services in settings.")
        default:
            break
        }
    }

    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        } else if status == .denied || status == .restricted {
            weatherViewState = .error("Location access denied. Please enable location services in settings.")
        }
    }
    
    @MainActor
    func fetchWeather(for location: CLLocation) async {
        weatherViewState = .loading
        do {
            let weather = try await weatherManager.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.weatherViewState = .data(weather)
        } catch {
            self.weatherViewState = .error(error.localizedDescription)
        }
    }
}

