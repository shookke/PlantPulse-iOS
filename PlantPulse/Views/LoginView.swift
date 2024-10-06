//
//  LoginView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/20/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var profile: Profile
    
    @State private var navigateToUserView = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField("Email", text: $profile.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                SecureField("Password", text: $profile.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if let error = profile.loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    Task() {
                        try await profile.login()
                    }
                }) {
                    Text("Login")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: RegisterView()) {
                    Text("Don't have and accout? Register")
                        .foregroundColor(.blue)
                        .padding()
                }
                .padding()
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToUserView) {
                HomeView()
                    .transition(.slide)
            }
            .onChange(of: profile.isLoggedIn) { isLoggedIn in
                if isLoggedIn {
                    DispatchQueue.main.async {
                        navigateToUserView = true
                    }
                }
            }
            .background(Color(red: 0.98, green: 0.97, blue: 0.92))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(Profile())
    }
}
