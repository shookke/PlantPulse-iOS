//
//  ExpirationHelper.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/21/24.
//

import Foundation

enum ExpirationParseError: Error {
    case invalidFormat
    case unsupportedUnit
}

struct ExpirationHelper {
    static func parseExpiresIn(from expiresIn: String) throws -> Date {
        let unit = String(expiresIn.suffix(1))
        guard let value = Double(expiresIn.dropLast()) else {
            throw ExpirationParseError.invalidFormat
        }
        let timeInterval: TimeInterval
        switch unit {
        case "d":
             timeInterval = value * 24 * 60 * 60
        case "h":
            timeInterval = value * 60 * 60
        case "m":
            timeInterval = value * 60
        case "s":
            timeInterval =  value
        default:
            throw ExpirationParseError.unsupportedUnit
        }
        
        return Date().addingTimeInterval(timeInterval)
    }
}
