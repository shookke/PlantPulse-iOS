//
//  Device.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/22/24.
//

import Foundation

struct Device: Identifiable, Codable {
    let id: String
    let deviceMAC: String
    let deviceType: String
    let plantType: String
    let user: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case deviceMAC
        case deviceType
        case plantType
        case user
        case createdAt
        case updatedAt
    }
}
