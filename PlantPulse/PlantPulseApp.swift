//
//  PlantPulseApp.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/16/24.
//

import SwiftUI

@main
struct PlantPulseApp: App {
    @StateObject var profile = Profile()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(profile)
                .onAppear {
                    isTokenValid()
                }
        }
    }
    
    func isTokenValid() {
        let token = KeychainHelper.shared.getAuthToken()
        let expiration = KeychainHelper.shared.getExpirationDate()
        
        if let token = token, let expiration = expiration {
            if expiration > Date() {
                profile.token = token
                profile.isLoggedIn = true
            } else {
                profile.isLoggedIn = false
            }
        } else {
            profile.isLoggedIn = false
        }
    }
}
