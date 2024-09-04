//
//  RegistrationError.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/26/24.
//

import Foundation

enum RegistrationError: Error, LocalizedError {
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
