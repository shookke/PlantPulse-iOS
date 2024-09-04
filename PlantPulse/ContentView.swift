//
//  ContentView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/16/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        VStack {
            if profile.isLoggedIn {
                MainView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            if let loadedUser = UserDefaultsHelper.loadUser() {
                profile.user = loadedUser
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Profile())
    }
}
