//
//  AreaAddPlantView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/31/24.
//

import SwiftUI

struct AreaAddPlantView: View {
    @Environment(\.dismiss) private var dismiss
    
    let areaId: String
    var onPlantAdded: (Plant) -> Void
    
    @StateObject private var viewModel = AreaAddPlantViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Plants...")
                        .padding()
                } else {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    if viewModel.plants.isEmpty {
                        Text("No plants available without an area.")
                            .padding()
                    } else {
                        // List with manual selection
                        List(viewModel.plants, id: \.id) { plant in
                            Button(action: {
                                viewModel.selectedPlant = plant
                            }) {
                                HStack {
                                    Text(plant.plantName)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if viewModel.selectedPlant?.id == plant.id {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .contentShape(Rectangle()) // Makes entire row tappable
                            }
                            .buttonStyle(PlainButtonStyle()) // Removes default button styling
                        }
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("Select a Plant")
                        
                        Button(action: {
                            // Confirm selection and update the plant's area
                            Task {
                                let success = await viewModel.updatePlantArea(areaId: areaId)
                                if success, let selectedPlant = viewModel.selectedPlant {
                                    onPlantAdded(selectedPlant)
                                    dismiss()
                                } else {
                                    // Optionally handle failure, perhaps show another alert or keep errorMessage
                                }
                            }
                        }) {
                            Text("Confirm Selection")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.selectedPlant != nil ? Color.blue : Color.gray)
                                .cornerRadius(8)
                        }
                        .disabled(viewModel.selectedPlant == nil || viewModel.isUpdating)
                        .padding([.horizontal, .bottom])
                        
                        if viewModel.isUpdating {
                            ProgressView("Updating Plant...")
                                .padding()
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchPlantsWithoutArea()
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AreaAddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock Plant and ViewModel
        let mockPlantType = PlantType(
            id: "123456789",
            image: nil,
            commonName: "Cactus",
            scientificName: "Cactus",
            family: "Cacticus",
            description: "",
            watering: "wet",
            lighting: "Bright",
            minLight: 1.0,
            maxLight: 100.0,
            uvA: 1.0,
            uvB: 1.0,
            uvC: 1.0,
            minTemperature: 1.0,
            maxTemperature: 1.0,
            minHumidity: 0.5,
            maxHumidity: 1.0,
            minSoilMoisture: 200.0,
            maxSoilMoisture: 2000.0,
            createdAt: "123456789",
            updatedAt: "123456789",
            v: 0
        )
        let mockPlant = Plant(
            id: "plant-123",
            plantType: mockPlantType,
            user: "user-123",
            container: nil,
            area: nil,
            plantName: "Cactus",
            datePlanted: nil,
            dateHarvested: nil,
            lastFertalization: nil,
            createdAt: "123456789",
            updatedAt: "123456789",
            v: 0,
            latestReading: nil
        )
        let viewModel = AreaAddPlantViewModel()
        viewModel.plants = [mockPlant]
        
        return AreaAddPlantView(areaId: "area-456") { newPlant in
            print("Plant added: \(newPlant.plantName)")
        }
        .environmentObject(viewModel)
    }
}
