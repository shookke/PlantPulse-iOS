//
//  User.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/22/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstname
        case lastname
        case email
    }
}
