//
//  AreaView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import SwiftUI

struct AreaView: View {
    @StateObject var viewModel = AreaViewModel()
    let area: Area
    let plants: [Plant]
    
    @State var showingAddOptions = false
    @State var showAddPlantView = false
    
    // Define adaptive grid layout
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            ScrollView{
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(plants) { plant in
                        NavigationLink(destination: PlantInfoView(plant: plant, areas: [])) {
                            PlantCardView(plant: plant)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(area.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddOptions = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.secondary, .green.opacity(0.25))
                }
            }
        }
        .confirmationDialog("Add New", isPresented: $showingAddOptions, titleVisibility: .hidden) {
            Button("Add Plant") {
                showAddPlantView = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showAddPlantView, onDismiss: refreshView) {
            AreaAddPlantView(areaId: area.id) { newPlant in
                
            }
        }
    }
    
    private func refreshView() {
        viewModel.loadData()
    }
}
