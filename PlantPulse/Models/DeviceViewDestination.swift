//
//  DeviceViewDestination.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/27/24.
//

import Foundation

enum DevicesViewDestination: Hashable {
    case deviceDetail(String) // Device ID
    case deviceRegistration
    case wiFiSetup
    case chooseHubDevice
    case plantId
    case deviceRegistrationCompletion
}
