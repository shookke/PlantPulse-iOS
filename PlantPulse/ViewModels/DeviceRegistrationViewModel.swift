//
//  DeviceRegistrationViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/31/24.
//

import Foundation
import ESPProvision

class DeviceRegistrationViewModel: ObservableObject {
    @Published var device: ESPDevice?
    
    init() {
        device = nil
    }
}

extension DeviceRegistrationView {
    
}
