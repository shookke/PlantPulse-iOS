//
//  AreaAddPlantViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/31/24.
//

import Foundation
import Combine

class AreaAddPlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var selectedPlant: Plant? = nil
    @Published var isLoading: Bool = false
    @Published var isUpdating: Bool = false
    @Published var errorMessage: String? = nil
    
    
    // Fetch plants that have no associated area
    @MainActor
    func fetchPlantsWithoutArea() async {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            let plantsResponse = try JSONDecoder().decode(PlantsResponse.self, from: data)
            
            guard !plantsResponse.plants.isEmpty else {
                print("No plants available.")
                self.plants = []
                return
            }
            self.plants = plantsResponse.plants.filter { $0.area == nil }

        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Update the selected plant's area via a PATCH request
    @MainActor
    func updatePlantArea(areaId: String) async -> Bool {
        guard let plant = selectedPlant else {
            self.errorMessage = "No plant selected."
            return false
        }
        
        self.isUpdating = true
        self.errorMessage = nil
        do {
            // Construct the PATCH URL by appending the plant's ID
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/\(plant.id)") else {
                throw APIError.invalidURL
            }
            
            let updateData: [String: Any] = [
                "updates": [
                    "area": areaId
                ]
            ]
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "PATCH", body: updateData)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            return true
        } catch (let error) {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
