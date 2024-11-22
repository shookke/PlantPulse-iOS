//
//  ToDoTask.swift
//  PlantPulse
//
//  Created by Kevin Shook on 11/21/24.
//

import Foundation

struct ToDoTask: Identifiable, Hashable, Codable {
    let id: String
    let user: String
    let plant: Plant
    let metric: String
    let message: String
    let status: String
    let createdAt: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case plant
        case metric
        case message
        case status
        case createdAt
        case v = "__v"
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
            user = try container.decode(String.self, forKey: .user)
        } catch {
            print("Failed to decode user: \(error)")
            throw error
        }
        
        do {
            plant = try container.decode(Plant.self, forKey: .plant)
        } catch {
            print("Failed to decode plant: \(error)")
            throw error
        }
        
        do {
            metric = try container.decode(String.self, forKey: .metric)
        } catch {
            print("Failed to decode metric: \(error)")
            throw error
        }
        
        do {
            message = try container.decode(String.self, forKey: .message)
        } catch {
            print("Failed to decode message: \(error)")
            throw error
        }
        
        do {
            status = try container.decode(String.self, forKey: .status)
        } catch {
            print("Failed to decode status: \(error)")
            throw error
        }
        
        do {
            createdAt = try container.decode(String.self, forKey: .createdAt)
        } catch {
            print("Failed to decode createdAt: \(error)")
            throw error
        }
        
        do {
            v = try container.decode(Int.self, forKey: .v)
        } catch {
            print("Failed to decode v: \(error)")
            throw error
        }
    }
}

struct TasksResponse: Codable {
    let todos: [ToDoTask]
}

struct TaskCompleteResponse: Codable {
    let todo: ToDoTask
}
