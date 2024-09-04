//
//  APIHelper.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/20/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidRequestBody
    case invalidResponse
    case noData
    case decodingError
    case unauthorized
    case serverError
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
                throw APIError.invalidRequestBody
            }
        }
        
        return request
        
    }
}
