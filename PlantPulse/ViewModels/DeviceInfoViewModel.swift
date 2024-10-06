//
//  DeviceInfoViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 11/1/24.
//

import Foundation

class DeviceInfoViewModel: ObservableObject {
    @Published var device: Device?
    @Published var errorMessage: String?
    
    init() {
        
    }
    
    @MainActor
    func removeDevice(device: Device) async -> Bool {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/devices/\(device.id)") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "DELETE", body: nil)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            return true
        } catch (let error) {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
}
