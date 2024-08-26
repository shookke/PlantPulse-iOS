//
//  MainView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/20/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
        }
        .tint(.green)
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Profile())
    }
}
