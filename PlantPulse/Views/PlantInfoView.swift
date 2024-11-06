//
//  PlantInfoView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/23/24.
//

import SwiftUI
import Charts

struct PlantInfoView: View {
    @Environment(\.dismiss)var dismiss
    
    @StateObject private var viewModel: PlantInfoViewModel
    
    @State private var showingAddOptions = false
    @State private var showAddDeviceView = false
    @State private var showDeletPlantView = false
    @State private var isDeleted = false
    
    init(plant: Plant, areas: [Area]) {
        _viewModel = StateObject(wrappedValue: PlantInfoViewModel(plant: plant, areas: areas))
    }
    
    var body: some View {
        VStack {
            if !viewModel.readings.isEmpty {
                ScrollView {
                    VStack{
                        HStack {
                            AsyncImage(url: viewModel.readings[0].rgbImage) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 115, height: 200)
                            } placeholder: {
                                ProgressView()
                            }
                            AsyncImage(url: viewModel.readings[0].ndviImage) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 115, height: 200)
                            } placeholder: {
                                ProgressView() // You can customize this placeholder
                            }

                            VStack{
                                Image(systemName: "drop.fill", variableValue: 0.5)
                                    .imageScale(.large)
                                    .foregroundStyle(.blue)
                                GeometryReader { geometry in
                                    ZStack(alignment: .bottom) {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 20)
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.blue)
                                            .frame(width: 20, height: geometry.size.height * ((viewModel.readings[0].soilMoisture-200)/(1800)))
                                    }
                                }
                            }
                            .frame(width: 20)
                        }
                        .padding(.horizontal)
                        Text("Temperature")
                            .font(.headline)
                        Chart(viewModel.readings) {
                            LineMark(
                                x: .value("Time", $0.createdAt),
                                y: .value("Temperature", $0.temperature)
                            )
                            .foregroundStyle(.red)
                        }
                        .frame(height: 200)
                        .padding()
                        
                        Text("Humidity")
                            .font(.headline)
                        Chart(viewModel.readings) {
                            LineMark(
                                x: .value("Time", $0.createdAt),
                                y: .value("Lux", $0.humidity*100)
                            )
                            .foregroundStyle(.blue)
                        }
                        .frame(height: 200)
                        .padding()
                        
                        Text("Light")
                            .font(.headline)
                        Chart(viewModel.readings) {
                            LineMark(
                                x: .value("Time", $0.createdAt),
                                y: .value("Temperature", $0.lux ?? 0.0)
                            )
                            .foregroundStyle(.red)
                        }
                        .frame(height: 200)
                        .padding()
                        
                        Text("UV")
                            .font(.headline)
                        Chart(viewModel.readings) {
                            LineMark(
                                x: .value("Time", $0.createdAt),
                                y: .value("UV A", $0.uvA),
                                series: .value("UV A", "A")
                            )
                            .foregroundStyle(.purple)
                            LineMark(
                                x: .value("Time", $0.createdAt),
                                y: .value("UV B", $0.uvB),
                                series: .value("UV B", "B")
                            )
                            .foregroundStyle(.green)
                            LineMark(
                                x: .value("Time", $0.createdAt),
                                y: .value("UV C", $0.uvC),
                                series: .value("UV C", "C")
                            )
                            .foregroundStyle(.orange)
                        }
                        .frame(height: 200)
                        .padding()
                    }
                }
            } else {
                ProgressView("Loading data...")
            }
        }
        .refreshable {
            viewModel.loadData()
        }
        .onChange(of: viewModel.isDeleted) { isDeleted in
            if isDeleted {
                dismiss()
            }
        }
        .navigationTitle(viewModel.plant.plantName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddOptions = true
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.secondary, .green.opacity(0.25))
                }
            }
        }
        .confirmationDialog("Add New", isPresented: $showingAddOptions, titleVisibility: .hidden) {
            Button("Add Device to Plant") {
                showAddDeviceView = true
            }
            Button("Remove Plant") {
                showDeletPlantView = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showAddDeviceView) {
            AddDeviceView { newDevice in
                viewModel.loadData()
            }.environmentObject(viewModel)
        }
        .alert(isPresented: $showDeletPlantView) {
            Alert(
                title: Text("Remove Plant"),
                message: Text("Are you sure you want to remove this plant? This action cannot be undone."),
                primaryButton: .destructive(Text("Remove")) {
                    Task {
                        await viewModel.removePlant()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    let plantType = PlantType(
        id: "123456789",
        image: "",
        commonName: "Ivy",
        scientificName:"Hedera Helix",
        family:"",
        description:"This is a plant.",
        watering:"wet",
        lighting:"Bright",
        minLight:10.0,
        maxLight:5000.0,
        uvA:50.0,
        uvB:20.0,
        uvC:15.0,
        minTemperature:-38.0,
        maxTemperature:50.0,
        minHumidity:0.05,
        maxHumidity:1.0,
        minSoilMoisture:300,
        maxSoilMoisture:1700,
        createdAt: "123456789",
        updatedAt: "123456789",
        v:0)
    let plant = Plant(
        id:"123456789",
        plantType: plantType,
        user: "123456789",
        container: nil,
        area: nil,
        plantName:"English Ivy",
        datePlanted: "123456789",
        dateHarvested: nil,
        lastFertalization: nil,
        createdAt:"123456789",
        updatedAt:"12345679",
        v:0,
        latestReading: nil)
    
    PlantInfoView(plant: plant, areas: [])
}
