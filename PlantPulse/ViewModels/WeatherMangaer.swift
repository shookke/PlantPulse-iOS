//
//  WeatherMangaer.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/27/24.
//

import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiKey = Secrets.apiKey
    
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {

        
        guard let url = buildURL(latitude: latitude, longitude: longitude) else {
                throw APIError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw APIError.serverError
            }
            
            let decoder = JSONDecoder()
            let weather = try decoder.decode(WeatherResponse.self, from: data)
            return weather
    }

    private func buildURL(latitude: Double, longitude: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/3.0/onecall"

        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "exclude", value: "minutely,alerts"),
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        return components.url
    }
}
