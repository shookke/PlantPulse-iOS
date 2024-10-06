//
//  Plant.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/31/24.
//

import Foundation

struct Plant: Identifiable, Hashable, Codable {
    let id: String
    let plantType: PlantType
    let user: String
    let container: Container?
    let area: Area?
    let plantName: String
    let datePlanted: String?
    let dateHarvested: String?
    let lastFertalization: String?
    let createdAt: String
    let updatedAt: String
    let v: Int
    let latestReading: Reading?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case plantType
        case user
        case container
        case area
        case plantName
        case datePlanted
        case dateHarvested
        case lastFertalization
        case createdAt
        case updatedAt
        case v = "__v"
        case latestReading
    }
}

struct Container: Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let width: Double
    let height: Double
    let length: Double
    let radius: Double
    let volume: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case width
        case height
        case length
        case radius
        case volume
    }
}

struct Area: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let icon: String?
    let description: String?
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case icon
        case description
        case v = "__v"
    }
}

extension Area {
    static let noArea = Area(id: "no-area", name: "No Area", icon: "", description: "Plants with not assigned an area.", v:0)
}

struct PlantType: Identifiable, Hashable, Codable {
    let id: String
    let image: String?
    let commonName: String
    let scientificName: String
    let family: String
    let description: String
    let watering: String
    let lighting: String
    let minLight: Double
    let maxLight: Double
    let uvA: Double
    let uvB: Double
    let uvC: Double
    let minTemperature: Double
    let maxTemperature: Double
    let minHumidity: Double
    let maxHumidity: Double
    let minSoilMoisture: Double
    let maxSoilMoisture: Double
    let createdAt: String
    let updatedAt: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case image
        case commonName
        case scientificName
        case family
        case description
        case watering
        case lighting
        case minLight
        case maxLight
        case uvA
        case uvB
        case uvC
        case minTemperature
        case maxTemperature
        case minHumidity
        case maxHumidity
        case minSoilMoisture
        case maxSoilMoisture
        case createdAt
        case updatedAt
        case v = "__v"
    }
}

struct AddPlant: Encodable {
    let plantType: String
    let container: String?
    let area: String?
    let plantName: String
    let datePlanted: String?
    let dateHarvested: String?
    let lastFertilization: String?
}

struct PlantsResponse: Codable {
    let plants: [Plant]
}

struct PlantTypesResponse: Codable {
    let plantTypes: [PlantType]
}
