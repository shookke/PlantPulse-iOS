//
//  Reading.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/22/24.
//

import Foundation

struct Reading: Codable {
    let id: String
    let temperature: Double
    let humidity: Double
    let lightLevel: Double
    let waterLevel: Double
    let createdAt: String
}
