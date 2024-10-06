//
//  DevicesViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/31/24.
//

import Foundation
import SwiftUI

class DevicesViewModel: ObservableObject {
    @Published var devices: [Device] = []
    @Published var deviceLoadError: String? = ""
    
    init() {
        loadData()
    }
    
}

extension DevicesViewModel {
    @MainActor
    func fetchDevices() async throws {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/devices/") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            guard let data = try? JSONDecoder().decode(DevicesResponse.self, from: data) else { throw APIError.noData }

            self.devices = data.devices
            
            
        } catch {
            deviceLoadError = error.localizedDescription
        }
    }
    
    func loadData() {
        Task(priority: .medium) {
           try await fetchDevices()
        }
    }
}

