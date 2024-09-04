//
//  HomeView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/24/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var profile: Profile
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.plants) { plant in
                    Text(plant.plantType.name)
                }
            }
            .refreshable {
                viewModel.loadData()
            }
            .navigationTitle("My Plants")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Profile())
    }
}
