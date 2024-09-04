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
    let plantType: String
    let user: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case deviceMAC
        case plantType
        case user
        case createdAt
        case updatedAt
    }
}
