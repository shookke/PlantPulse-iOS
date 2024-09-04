//
//  RegisterViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/24/24.
//

import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var pwConfirm: String = ""
    @Published var registrationError: String?
    @Published var isSuccess: Bool = false
    
}
extension RegisterViewModel {
    @MainActor
    func register() async throws {
        if !isValid() {
            return
        }
        guard let url = URL(string: "\(NetworkConstants.baseURL)/users/register") else {
            throw APIError.invalidURL
        }
        
        let registerData = [
            "firstname": firstname,
            "lastname": lastname,
            "email": email,
            "password": password
        ]
        
        let request = try APIHelper.shared.formatRequest(url: url, method: "POST", body: registerData)
        
        // Create and run the URLSession
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate the response
        guard (response as? HTTPURLResponse)?.statusCode == 201 else { throw APIError.serverError }
        
        guard let _ = try? JSONDecoder().decode(UserResponse.self, from: data) else {return}
    }
    
    func isValid() -> Bool {
        guard !firstname.trimmingCharacters(in: .whitespaces).isEmpty,
              !lastname.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            registrationError = "Please fill in all fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            registrationError = "Please enter a valid email."
            return false
        }
        
        guard (password.count >= 8) else {
            registrationError = "Password must be a minimum of 8 characters."
            return false
        }
        guard (isPasswordValid()) else {
            registrationError = """
                Password must contain atleast:
                    1 Uppercase letter
                    1 Lowercase letter
                    1 Number
                    1 Special Character
            """
            return false
        }
        guard (password == pwConfirm) else {
            registrationError = "Passwords do not match."
            return false
        }
        return true
    }
    
    private func isPasswordValid() -> Bool {
        let lowercasePattern = ".*[a-z]+.*"
        let uppercasePattern = ".*[A-Z]+.*"
        let numberPattern = ".*[0-9]+.*"
        let specialCharacterPattern = ".*[^A-Za-z0-9]+.*"
        
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", lowercasePattern)
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercasePattern)
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberPattern)
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterPattern)
        
        return lowercasePredicate.evaluate(with: password) &&
        uppercasePredicate.evaluate(with: password) &&
        numberPredicate.evaluate(with: password) &&
        specialCharacterPredicate.evaluate(with: password)
    }
}
    
