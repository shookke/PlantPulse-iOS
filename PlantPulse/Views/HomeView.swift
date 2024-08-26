//
//  HomeView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/24/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var profile: Profile
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Text("Hello, \(profile.user.firstname)!")
            List(profile.user.devices) { device in
                VStack(alignment: .leading) {
                    Text(device.plantType)
                        .font(.headline)
                }
            }
            .onAppear {
                do {
                    viewModel.fetchDevices(userId: profile.user.id)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Profile())
    }
}
