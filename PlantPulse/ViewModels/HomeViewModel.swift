//
//  HomeViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/24/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @EnvironmentObject var profile: Profile
    
    @Published var deviceLoadError: String? = ""
    
    
    func fetchDevices(userId: String) {
        APIService.shared.fetchDevices(userId: userId) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let newDevices):
                    profile.user.devices.append(contentsOf: newDevices)
                case .failure(let error):
                    self.deviceLoadError = error.localizedDescription
                }
            }
        }
    }
}

