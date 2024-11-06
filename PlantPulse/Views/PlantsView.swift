//
//  PlantsView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/27/24.
//

import SwiftUI

struct PlantsView: View {
    @EnvironmentObject var profile: Profile
    @StateObject private var viewModel = PlantsViewModel()
    @State private var addPlant = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.plants.compactMap { $0 }) { (plant: Plant) in
                NavigationLink(destination: PlantInfoView(plant: plant, areas: [])) {
                    Text(plant.plantName)
                }
            }
            .refreshable {
                viewModel.loadData()
            }
            .navigationDestination(isPresented: $addPlant, destination: {
                NewPlantView()
            })
            .navigationTitle("My Plants")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { addPlant = true }) {
                        Image(systemName: "plus")
                            .padding()
                    }
                }
            }

        }
        
    }
}

#Preview {
    PlantsView()
}
