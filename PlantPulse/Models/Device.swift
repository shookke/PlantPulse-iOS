//
//  Device.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/22/24.
//

import Foundation

struct Device: Identifiable, Codable {
    let id: String
    let deviceType: String
    let deviceUUID: String
    let user: String
    let connectedDevices: [Device]
    let plants: [Plant]
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case deviceType
        case deviceUUID
        case user
        case connectedDevices
        case plants
        case createdAt
        case updatedAt
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
            deviceType = try container.decode(String.self, forKey: .deviceType)
        } catch {
            print("Failed to decode deviceType: \(error)")
            throw error
        }

        do {
            deviceUUID = try container.decode(String.self, forKey: .deviceUUID)
        } catch {
            print("Failed to decode deviceUUID: \(error)")
            throw error
        }

        do {
            user = try container.decode(String.self, forKey: .user)
        } catch {
            print("Failed to decode user: \(error)")
            throw error
        }

        do {
            connectedDevices = try container.decode([Device].self, forKey: .connectedDevices)
        } catch {
            print("Failed to decode connectedDevices: \(error)")
            throw error
        }

        do {
            plants = try container.decode([Plant].self, forKey: .plants)
        } catch {
            print("Failed to decode plants: \(error)")
            throw error
        }

        do {
            createdAt = try container.decode(String.self, forKey: .createdAt)
        } catch {
            print("Failed to decode createdAt: \(error)")
            throw error
        }

        do {
            updatedAt = try container.decode(String.self, forKey: .updatedAt)
        } catch {
            print("Failed to decode updatedAt: \(error)")
            throw error
        }
    }
}
