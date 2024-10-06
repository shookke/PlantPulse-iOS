//
//  APIHelper.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/20/24.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case serverError
    case decodingError
    case encodingError
    case custom(String)
    case unknownError
    case noData // Added this case

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .serverError:
            return "There was an error with the server."
        case .decodingError:
            return "Failed to decode the response."
        case .encodingError:
            return "Failed to encode the request body."
        case .custom(let message):
            return message
        case .unknownError:
            return "An unknown error occurred."
        case .noData:
            return "No plant types available."
        }
    }
}


class APIHelper {
    static let shared = APIHelper()
    
    private init() {}
    
    func formatRequest(url: URL, method: String, body: [String: Any]?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(nil, forHTTPHeaderField: "If-Modified-Since")
        request.setValue(nil, forHTTPHeaderField: "If-None-Match")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        if let token = KeychainHelper.shared.getAuthToken() {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        // Set request body if provided
        if let body = body {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonData
            } catch {
                throw APIError.encodingError
            }
        }
        
        return request
        
    }
}
