//
//  AreaViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/31/24.
//

import Foundation

class AreaViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var plantsLoadError: String? = ""
    
    init() {
        
    }
    
    func loadData() {
        Task {
            await fetchPlants()
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

        } catch {
            plantsLoadError = error.localizedDescription
        }
    }
}
