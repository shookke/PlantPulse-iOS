//
//  PlantIDViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/20/24.
//

import Foundation
import SwiftUI

class PlantIDViewModel: ObservableObject {
    @Published var plantsList: [PlantType] = []
    @Published var plantsLoadError: String? = ""
    @Published var plantTypeId: String = ""
    @Published var isLoading: Bool = false
    
    init() {
        isLoading = true
        loadData()
        isLoading = false
    }
}

extension PlantIDViewModel {
    @MainActor
    func fetchPlantTypes() async throws {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plantTypes/") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            let decoder = JSONDecoder()
            //decoder.dateDecodingStrategy = .iso8601 // Set the date decoding strategy
            guard let data = try? decoder.decode(PlantTypesResponse.self, from: data) else { throw APIError.noData }
            
            
        } catch {
            plantsLoadError = error.localizedDescription
        }
    }

    func loadData() {
        Task(priority: .medium) {
            try await fetchPlantTypes()
        }
    }
}
