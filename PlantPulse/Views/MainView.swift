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
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                DevicesView()
                    .tabItem {
                        Image(systemName: "point.3.filled.connected.trianglepath.dotted")
                    }
                ScheduleView()
                    .tabItem {
                        Image(systemName: "calendar")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
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

