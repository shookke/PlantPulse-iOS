//
//  UserViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/22/24.
//

import Foundation
import SwiftUI

class Profile: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: User
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var token: String = ""
    @Published var loginError: String?
    
    init() {
        self.user = User(
            id: "",
            firstname: "",
            lastname: "",
            email: ""
        );
    }
    
}
extension Profile {
    @MainActor
    func login() async throws {
        if !isValid() {
            return
        }
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/users/login") else {
                throw APIError.invalidURL
            }
            
            let loginData: [String: Any] = [
                "email": self.email,
                "password": self.password,
                "stayLoggedIn": true
            ]
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "POST", body: loginData)
            
            // Create and run the URLSession
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Validate the response
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            guard let data = try? JSONDecoder().decode(LoginResponse.self, from: data) else { throw APIError.noData }
            
            self.token = data.token
            let expiresIn = data.expiresIn
            self.user = data.user
            
            // Store User data in local storage
            UserDefaultsHelper.saveUser(data.user)
            
            
            var expiration = Date().addingTimeInterval(120)
            do {
                let date = try ExpirationHelper.parseExpiresIn(from: expiresIn)
                expiration = date
            } catch {
                self.loginError = error.localizedDescription
            }
            KeychainHelper.shared.saveAuthToken(token, expiration: expiration)
            
            self.isLoggedIn = true
            
        } catch {
            self.loginError = error.localizedDescription
        }
    }
    
    func signOut() {
        KeychainHelper.shared.deleteAuthToken()
        removeUser()
        self.isLoggedIn = false
    }
    
    private func isValid() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            loginError = "Please fill in all fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            loginError = "Please enter a valid email."
            return false
        }
        return true
    }
    
    private func checkForExistingToken() async throws {
        let renewPeriod: Double = 30 * 24 * 60 * 60
        // Check if token exists in Keychain
        if let _ = KeychainHelper.shared.getAuthToken(),
           let expirationDate = KeychainHelper.shared.getExpirationDate() {
            if Date().addingTimeInterval(renewPeriod) < expirationDate {
                self.isLoggedIn = true
            } else if Date().addingTimeInterval(renewPeriod) >= expirationDate {
                self.isLoggedIn = true
                do {
                    try await renewToken()
                } catch {
                    loginError = error.localizedDescription
                }
            } else {
                self.isLoggedIn = false
            }
        } else {
            self.isLoggedIn = false
        }
    }
    
    private func renewToken() async throws {
        if self.isLoggedIn {
            do {
                guard let url = URL(string: "\(NetworkConstants.baseURL)/users/renewToken") else {
                    throw APIError.invalidURL
                }
                
                let request = try APIHelper.shared.formatRequest(url: url, method: "POST", body: nil)
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
                
                guard let data = try? JSONDecoder().decode(LoginResponse.self, from: data) else { throw APIError.noData }
                            
                self.token = data.token
                let expiresIn = data.expiresIn
                var expiration = Date().addingTimeInterval(120) // defaults to 1h
                
                do {
                    let date = try ExpirationHelper.parseExpiresIn(from: expiresIn)
                    expiration = date
                } catch {
                    self.loginError = error.localizedDescription
                }
                
                self.user = data.user
                KeychainHelper.shared.saveAuthToken(token, expiration: expiration)
                
                isLoggedIn = true
            } catch {
                self.loginError = error.localizedDescription
            }
        }
    }
    
    private func saveToKeychain(token: String, expiration: String) {
        do {
            let expiration = try ExpirationHelper.parseExpiresIn(from: expiration)
            KeychainHelper.shared.saveAuthToken(token, expiration: expiration)
        } catch {
            return
        }
    }
    
    private func removeUser() {
        self.user = User(
            id: "",
            firstname: "",
            lastname: "",
            email: ""
        );
        UserDefaultsHelper.removeUser()
    }
    
    
}
