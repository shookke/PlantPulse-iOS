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
            email: "",
            devices: []
        );
    }
    
    func login() {
        if !isValid() {
            return
        }
        APIService.shared.login(email: self.email, password: self.password) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                    
                case .success(let response):
                    
                    let token = response.token
                    let expiresIn = response.expiresIn
                    
                   do {
                        // Parse the expiresIn astring and get the time interval in secons
                        let expirationDate = try ExpirationHelper.parseExpiresIn(from: expiresIn)
                        
                        // Save token and expiration in Keychain
                        KeychainHelper.shared.saveAuthToken(token, expiration: expirationDate)
                        
                    } catch {
                        self.loginError = "Error saving token to keychain"
                    }
                    
                    // Update UserViewModel with user data
                    self.user = response.user
                                            
                    // Update login state
                    self.isLoggedIn = true
                    
                case .failure(let error):
                    self.loginError = error.localizedDescription
                }
            }
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
    
    private func checkForExistingToken() {
        let renewPeriod: Double = 30 * 24 * 60 * 60
        // Check if token exists in Keychain
        if let _ = KeychainHelper.shared.getAuthToken(),
           let expirationDate = KeychainHelper.shared.getExpirationDate() {
            if Date().addingTimeInterval(renewPeriod) < expirationDate {
                self.isLoggedIn = true
            } else if Date().addingTimeInterval(renewPeriod) >= expirationDate {
                self.isLoggedIn = true
                renewToken()
            } else {
                self.isLoggedIn = false
            }
        } else {
            self.isLoggedIn = false
        }
    }
    
    private func renewToken() {
        if self.isLoggedIn {
            guard let token = KeychainHelper.shared.getAuthToken() else { return }
            APIService.shared.renewToken(token: token) { result in
                switch result {
                case .success(let response):
                    let token = response.token
                    let expiresInString = response.expiresIn
                    
                    if let expirationDate = try? ExpirationHelper.parseExpiresIn(from: expiresInString){
                        KeychainHelper.shared.saveAuthToken(token, expiration: expirationDate)
                    }
                case .failure(let error):
                    print("Failure to renew token: \(error.localizedDescription)")
                }
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
            email: "",
            devices: []
        );
    }
    
    private func addDevice(newDevice: Device) {
        user.devices.append(newDevice)
    }
    
    
}
