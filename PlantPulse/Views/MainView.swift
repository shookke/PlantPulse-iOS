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
            Group {
                HomeView()
                    .tabItem {
                        Image(systemName: "leaf")
                        Text("My Plants")
                    }
                TasksView()
                    .tabItem {
                        Image(systemName: "checkmark.square.fill")
                        Text("Tasks")
                    }
                DevicesView()
                    .tabItem {
                        Image(systemName: "sensor.fill")
                        Text("Devices")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
            }
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
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

