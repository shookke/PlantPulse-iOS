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
    
    func register() {
        if !isValid() {
            return
        }
        APIService.shared.registerUser(firstname: self.firstname, lastname: self.lastname, email: self.email, password: self.password) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                    case .success(_):
                        self.isSuccess = true
                        self.registrationError = nil
                    case .failure(let error):
                        self.registrationError = error.localizedDescription
                }
            }
        }
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
