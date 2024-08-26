//
//  LoginResponse.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/20/24.
//

import Foundation

// Model representing the login response
struct LoginResponse: Codable {
    let token: String
    let expiresIn: String
    let user: User
}
