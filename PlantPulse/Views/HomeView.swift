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
            VStack {
                List(viewModel.plants.compactMap { $0 }) { (plant: Plant) in
                    Text(plant.plantType.commonName)
                }
                .refreshable {
                    viewModel.loadData()
                }
                .navigationTitle("My Plants")
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
