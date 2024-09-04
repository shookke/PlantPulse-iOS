//
//  Plant.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/31/24.
//

import Foundation

struct Plant: Identifiable, Codable {
    let id: String
    let plantType: PlantType
    let user: User
    let container: Container
    let location: Area
    let datePlanted: Date
    let dateHarvested: Date
    let lastFertalization: Date
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case plantType
        case user
        case container
        case location
        case datePlanted
        case dateHarvested
        case lastFertalization
        case createdAt
        case updatedAt
    }
}

struct Container: Codable {
    let name: String
    let description: String
    let width: Double
    let height: Double
    let length: Double
    let radius: Double
    let volume: Double
}

struct Area: Codable {
    let name: String
    let icon: String
    let description: String
}

struct PlantType: Codable {
    let name: String
    let family: String
    let description: String
    let watering: String
    let lighting: String
    let uvIndex: Double
    let temperature: Double
    let humidity: Double
    let soilMoisture: Double
}
