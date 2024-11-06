//
//  PlantInfoViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/25/24.
//

import Foundation
import SwiftUI

class PlantInfoViewModel: ObservableObject {
    @EnvironmentObject var profile: Profile
    
    @Published var readings = [Reading]()
    @Published var readingsLoadError: String? = ""
    @Published var plant: Plant
    @Published var areas: [Area] = []
    @Published var isDeleted = false
    
    init(plant: Plant, areas: [Area]) {
        self.plant = plant
        self.areas = areas
        if self.areas.isEmpty {
            Task {
                try await fetchAreas()
            }
        }
        loadData()
    }
}

extension PlantInfoViewModel {
    @MainActor
    func fetchReadings() async throws {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/readings/\(plant.id)") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            guard let data = try? JSONDecoder().decode(ReadingsResponse.self, from: data) else { throw APIError.noData }
            
            self.readings = data.readings
            
        } catch {
            readingsLoadError = error.localizedDescription
        }
    }
    
    func fetchAreas() async throws {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/areas/") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }

            guard let data = try? JSONDecoder().decode(AreasResponse.self, from: data) else { throw APIError.noData }
            
            self.areas = data.areas
            
        } catch {
            readingsLoadError = error.localizedDescription
        }
    }
    
    @MainActor
    func removePlant() async {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/\(plant.id)") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "DELETE", body: nil)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 204 else { throw APIError.serverError }
            
            self.isDeleted = true
            
        } catch {
            readingsLoadError = error.localizedDescription
        }
    }
    
    func loadData() {
        Task(priority: .medium) {
            try await fetchReadings()
        }
    }
}


