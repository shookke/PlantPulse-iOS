//
//  PlantsViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/27/24.
//

import Foundation

class PlantsViewModel: ObservableObject {
    @Published var plants = [Plant]()
    @Published var plantsLoadError: String = ""
    
    init() {
        loadData()
    }
}

extension PlantsViewModel {
    @MainActor
    func fetchPlants() async throws {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            let decoder = JSONDecoder()
            //decoder.dateDecodingStrategy = .iso8601 // Set the date decoding strategy
            guard let data = try? decoder.decode(PlantsResponse.self, from: data) else { throw APIError.noData }
            
            self.plants = data.plants
            
        } catch {
            plantsLoadError = error.localizedDescription
        }
    }
    
    func loadData() {
        Task(priority: .medium) {
            try await fetchPlants()
        }
    }
}
