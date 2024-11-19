//
//  Reading.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/22/24.
//

import Foundation

struct Reading: Identifiable, Hashable, Codable {
    let id: String
    let imageFilename: String
    let temperature: Double
    let humidity: Double
    let uvA: Double
    let uvB: Double
    let uvC: Double
    let soilMoisture: Double
    let createdAt: Date
    let updatedAt: Date
    let v: Int
    let lux: Double?
    let rgbImage: URL
    let ndviImage: URL
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case imageFilename
        case temperature
        case humidity
        case uvA
        case uvB
        case uvC
        case soilMoisture
        case createdAt
        case updatedAt
        case v = "__v"
        case lux
        case rgbImage
        case ndviImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each field and log any potential failure
        do {
            id = try container.decode(String.self, forKey: .id)
        } catch {
            print("Failed to decode id: \(error)")
            throw error
        }
        
        do {
            imageFilename = try container.decode(String.self, forKey: .imageFilename)
        } catch {
            print("Failed to decode imageFilename: \(error)")
            throw error
        }

        do {
            temperature = try container.decode(Double.self, forKey: .temperature)
        } catch {
            print("Failed to decode temperature: \(error)")
            throw error
        }

        do {
            humidity = try container.decode(Double.self, forKey: .humidity)
        } catch {
            print("Failed to decode humidity: \(error)")
            throw error
        }

        do {
            lux = try container.decode(Double.self, forKey: .lux)
        } catch {
            print("Failed to decode lux: \(error)")
            lux = 0.0
        }
        
        do {
            uvA = try container.decode(Double.self, forKey: .uvA)
        } catch {
            print("Failed to decode uvA: \(error)")
            throw error
        }

        do {
            uvB = try container.decode(Double.self, forKey: .uvB)
        } catch {
            print("Failed to decode uvB: \(error)")
            throw error
        }

        do {
            uvC = try container.decode(Double.self, forKey: .uvC)
        } catch {
            print("Failed to decode uvC: \(error)")
            throw error
        }

        do {
            soilMoisture = try container.decode(Double.self, forKey: .soilMoisture)
        } catch {
            print("Failed to decode waterLevel: \(error)")
            soilMoisture = 200
        }

        do {
            let createdAtString = try container.decode(String.self, forKey: .createdAt)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: createdAtString) {
                createdAt = date
            } else {
                throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
        } catch {
            print("Failed to decode createdAt: \(error)")
            throw error
        }

        do {
            let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: updatedAtString) {
                updatedAt = date
            } else {
                throw DecodingError.dataCorruptedError(forKey: .updatedAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
        } catch {
            print("Failed to decode updatedAt: \(error)")
            throw error
        }
        
        do {
            v = try container.decode(Int.self, forKey: .v)
        } catch {
            print("Failed to decode v: \(error)")
            throw error
        }

        do {
            rgbImage = try container.decode(URL.self, forKey: .rgbImage)
        } catch {
            print("Failed to decode rgbImage: \(error)")
            rgbImage = URL(filePath: "")!
        }

        do {
            ndviImage = try container.decode(URL.self, forKey: .ndviImage)
        } catch {
            print("Failed to decode ndviImage: \(error)")
            ndviImage = URL(filePath: "")!
        }
    }
}

struct Prediction: Codable {
    let label: String
    let confidence: Double
}

struct ReadingsResponse: Codable {
    let readings: [Reading]
    let prediction: Prediction?
}
