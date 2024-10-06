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

enum UserRegistrationError: Error, LocalizedError {
    case invalidEmail
    case invalidPassword
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidPassword:
            return "Please enter a valid password."
        }
    }
}

struct UserResponse: Codable {
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

// Model representing the login response
struct LoginResponse: Codable {
    let token: String
    let expiresIn: String
    let user: User
}
