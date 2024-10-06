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
    
    init(plant: Plant) {
        self.plant = plant
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
            
            let decoder = JSONDecoder()
            //decoder.dateDecodingStrategy = .iso8601 // Set the date decoding strategy
            guard let data = try? decoder.decode(ReadingsResponse.self, from: data) else { throw APIError.noData }
            
            self.readings = data.readings
            
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


