//
//  APIService.swift
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
}

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    private func sendRequest<T: Codable>(url: URL, method: String, token: String?,  body: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set request body if provided
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(APIError.invalidRequestBody))
                return
            }
        }
        
        // Create and run the URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                // Decode response data into the expected Model
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }.resume()
    }
    
    func registerUser(firstname: String, lastname: String, email: String, password: String, completion: @escaping (Result<RegistrationResponse, Error>) -> Void) {
        guard let url = URL(string: "\(NetworkConstants.baseURL)/users/register") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let registerData = [
            "firstname": firstname,
            "lastname": lastname,
            "email": email,
            "password": password
        ]
        
        sendRequest(url: url, method: "POST", token: "", body: registerData, completion: completion)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "\(NetworkConstants.baseURL)/users/login") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let loginData = [
            "email": email,
            "password": password
        ]
        
        sendRequest(url: url, method: "POST", token: "", body: loginData, completion: completion)
    }
    
    func fetchDevices(userId: String, completion: @escaping (Result<[Device], Error>) -> Void) {
        let token = KeychainHelper.shared.getAuthToken()
        
        guard let url = URL(string: "\(NetworkConstants.baseURL)/devices/") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        sendRequest(url: url, method: "GET", token: token, body:[:], completion: completion)
    }
    
    func renewToken(token: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "\(NetworkConstants.baseURL)/users/renewToken") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let token = KeychainHelper.shared.getAuthToken() else { return }
        let loginData = ["token": token]
        
        sendRequest(url: url, method: "POST", token: "", body: loginData, completion: completion)
    }
    
    
}
