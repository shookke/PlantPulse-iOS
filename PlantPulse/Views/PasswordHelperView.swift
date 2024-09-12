//
//  PasswordHelperView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/9/24.
//

import SwiftUI

struct PasswordHelperView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Password Requirements:")
                .font(.headline)
                .padding(.bottom, 5)
            RequirementView(text: "At least 8 characters", isValid: isLengthValid(password: viewModel.password))
            RequirementView(text: "At least 1 uppercase letter", isValid: hasUppercase(password: viewModel.password))
            RequirementView(text: "At least 1 lowercase letter", isValid: hasLowercase(password: viewModel.password))
            RequirementView(text: "At least 1 number", isValid: hasNumber(password: viewModel.password))
            RequirementView(text: "At least 1 special character", isValid: hasSpecialCharacter(password: viewModel.password))
        }
    }
}

private func isLengthValid(password: String) -> Bool {
    return password.count >= 8
}

private func hasUppercase(password: String) -> Bool {
    let uppercasePattern = ".*[A-Z]+.*"
    return NSPredicate(format: "Self MATCHES %@", uppercasePattern).evaluate(with: password)
}

private func hasLowercase(password: String) -> Bool {
    let lowercasePattern = ".*[a-z]+.*"
    return NSPredicate(format: "Self MATCHES %@", lowercasePattern).evaluate(with: password)
}

private func hasNumber(password: String) -> Bool {
    let numberPattern = ".*[0-9]+.*"
    return NSPredicate(format: "Self MATCHES %@", numberPattern).evaluate(with: password)
}

private func hasSpecialCharacter(password: String) -> Bool {
    let specialPattern = ".*[!@#$%^&*(),.?\":{}|<>`~]+.*"
    return NSPredicate(format: "Self MATCHES %@", specialPattern).evaluate(with: password)
}

struct RequirementView: View {
    var text: String
    var isValid: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isValid ? .green : .gray)
            Text(text)
                .foregroundColor(.black)
        }
    }
}

struct PasswordHelperView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordHelperView(viewModel: RegisterViewModel(password: "password"))
    }
}
