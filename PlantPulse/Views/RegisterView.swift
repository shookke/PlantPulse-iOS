//
//  RegisterView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/20/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isSuccess {
                Text("Thank you for registering!")
                    .foregroundColor(.green)
                    .padding()
            }
            TextField("Firstname", text: $viewModel.firstname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Lastname", text: $viewModel.lastname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Confirm Password", text: $viewModel.pwConfirm)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let error = viewModel.registrationError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                Task() {
                    try await viewModel.register()
                }
            }) {
                Text("Register")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
