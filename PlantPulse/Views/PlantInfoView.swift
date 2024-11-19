//
//  PlantInfoView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/23/24.
//

import SwiftUI
import Charts

struct PlantInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: PlantInfoViewModel
    
    @State private var showingAddOptions = false
    @State private var showAddDeviceView = false
    @State private var showDeletePlantView = false
    @State private var showPlantDetailsView = false
    
    // State variables for tooltips
    @State private var selectedTemperatureReading: Reading?
    @State private var selectedHumidityReading: Reading?
    @State private var selectedLightReading: Reading?
    @State private var selectedUVReading: Reading?
    @State private var temperatureTooltipPosition: CGPoint = .zero
    @State private var humidityTooltipPosition: CGPoint = .zero
    @State private var lightTooltipPosition: CGPoint = .zero
    @State private var uvTooltipPosition: CGPoint = .zero

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
                                ProgressView()
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
                                            .frame(width: 20, height: geometry.size.height * ((viewModel.readings[0].soilMoisture - 200) / (1800)))
                                    }
                                }
                            }
                            .frame(width: 20)
                        }
                        .padding(.horizontal)
                        
                        Text("Assigned Plant Type: \(viewModel.plant.plantType.scientificName)")
                            //.fontWeight(.ultraLight)
                            .font(.footnote)
                        if let prediction = viewModel.prediction {
                            Text(
                                "Predicted Plant Type: \(prediction.label) Confidence: \(prediction.confidence)"
                            )
                            //.fontWeight(.ultraLight)
                            .font(.footnote)
                        } else {
                            EmptyView()
                        }
                        
                        // Temperature Chart with Tooltip
                        Text("Temperature")
                            .font(.headline)
                        Chart(viewModel.readings) { reading in
                            LineMark(
                                x: .value("Time", reading.createdAt),
                                y: .value("Temperature", reading.temperature)
                            )
                            .foregroundStyle(.red)
                        }
                        .frame(height: 200)
                        .padding()
                        .chartOverlay { proxy in
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.clear)
                                    .contentShape(Rectangle())
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                let location = value.location
                                                if let date: Date = proxy.value(atX: location.x - geometry[proxy.plotAreaFrame].origin.x),
                                                   let reading = findClosestReading(to: date) {
                                                    selectedTemperatureReading = reading
                                                    if let xPosition = proxy.position(forX: reading.createdAt),
                                                       let yPosition = proxy.position(forY: reading.temperature) {
                                                        temperatureTooltipPosition = CGPoint(
                                                            x: xPosition + geometry[proxy.plotAreaFrame].origin.x,
                                                            y: yPosition + geometry[proxy.plotAreaFrame].origin.y
                                                        )
                                                    }
                                                }
                                            }
                                            .onEnded { _ in
                                                selectedTemperatureReading = nil
                                            }
                                    )
                            }
                        }
                        .overlay(alignment: .topLeading) {
                            if let reading = selectedTemperatureReading {
                                TooltipView(reading: reading, valueKey: "temperature")
                                    .position(x: temperatureTooltipPosition.x, y: temperatureTooltipPosition.y - 40)
                            }
                        }
                        
                        // Humidity Chart with Tooltip
                        Text("Humidity")
                            .font(.headline)
                        Chart(viewModel.readings) { reading in
                            LineMark(
                                x: .value("Time", reading.createdAt),
                                y: .value("Humidity", reading.humidity)
                            )
                            .foregroundStyle(.blue)
                        }
                        .frame(height: 200)
                        .padding()
                        .chartOverlay { proxy in
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.clear)
                                    .contentShape(Rectangle())
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                let location = value.location
                                                if let date: Date = proxy.value(atX: location.x - geometry[proxy.plotAreaFrame].origin.x),
                                                   let reading = findClosestReading(to: date) {
                                                    selectedHumidityReading = reading
                                                    if let xPosition = proxy.position(forX: reading.createdAt),
                                                       let yPosition = proxy.position(forY: reading.humidity) {
                                                        humidityTooltipPosition = CGPoint(
                                                            x: xPosition + geometry[proxy.plotAreaFrame].origin.x,
                                                            y: yPosition + geometry[proxy.plotAreaFrame].origin.y
                                                        )
                                                    }
                                                }
                                            }
                                            .onEnded { _ in
                                                selectedHumidityReading = nil
                                            }
                                    )
                            }
                        }
                        .overlay(alignment: .topLeading) {
                            if let reading = selectedHumidityReading {
                                TooltipView(reading: reading, valueKey: "humidity")
                                    .position(x: humidityTooltipPosition.x, y: humidityTooltipPosition.y - 40)
                            }
                        }
                        
                        // Light Chart with Tooltip
                        Text("Light")
                            .font(.headline)
                        Chart(viewModel.readings) { reading in
                            LineMark(
                                x: .value("Time", reading.createdAt),
                                y: .value("Light", reading.lux ?? 0.0)
                            )
                            .foregroundStyle(.yellow)
                        }
                        .frame(height: 200)
                        .padding()
                        .chartOverlay { proxy in
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.clear)
                                    .contentShape(Rectangle())
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                let location = value.location
                                                if let date: Date = proxy.value(atX: location.x - geometry[proxy.plotAreaFrame].origin.x),
                                                   let reading = findClosestReading(to: date) {
                                                    selectedLightReading = reading
                                                    if let xPosition = proxy.position(forX: reading.createdAt),
                                                       let yPosition = proxy.position(forY: reading.lux ?? 0.0) {
                                                        lightTooltipPosition = CGPoint(
                                                            x: xPosition + geometry[proxy.plotAreaFrame].origin.x,
                                                            y: yPosition + geometry[proxy.plotAreaFrame].origin.y
                                                        )
                                                    }
                                                }
                                            }
                                            .onEnded { _ in
                                                selectedLightReading = nil
                                            }
                                    )
                            }
                        }
                        .overlay(alignment: .topLeading) {
                            if let reading = selectedLightReading {
                                TooltipView(reading: reading, valueKey: "lux")
                                    .position(x: lightTooltipPosition.x, y: lightTooltipPosition.y - 40)
                            }
                        }
                        
                        // UV Chart with Tooltip
                        Text("UV")
                            .font(.headline)
                        Chart {
                            ForEach(viewModel.readings) { reading in
                                LineMark(
                                    x: .value("Time", reading.createdAt),
                                    y: .value("UV A", reading.uvA)
                                )
                                .foregroundStyle(.purple)
                                LineMark(
                                    x: .value("Time", reading.createdAt),
                                    y: .value("UV B", reading.uvB)
                                )
                                .foregroundStyle(.green)
                                LineMark(
                                    x: .value("Time", reading.createdAt),
                                    y: .value("UV C", reading.uvC)
                                )
                                .foregroundStyle(.orange)
                            }
                        }
                        .frame(height: 200)
                        .padding()
                        .chartOverlay { proxy in
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Color.clear)
                                    .contentShape(Rectangle())
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                let location = value.location
                                                if let date: Date = proxy.value(atX: location.x - geometry[proxy.plotAreaFrame].origin.x),
                                                   let reading = findClosestReading(to: date) {
                                                    selectedUVReading = reading
                                                    if let xPosition = proxy.position(forX: reading.createdAt),
                                                       let yPosition = proxy.position(forY: reading.uvA) {
                                                        uvTooltipPosition = CGPoint(
                                                            x: xPosition + geometry[proxy.plotAreaFrame].origin.x,
                                                            y: yPosition + geometry[proxy.plotAreaFrame].origin.y
                                                        )
                                                    }
                                                }
                                            }
                                            .onEnded { _ in
                                                selectedUVReading = nil
                                            }
                                    )
                            }
                        }
                        .overlay(alignment: .topLeading) {
                            if let reading = selectedUVReading {
                                UVTooltipView(reading: reading)
                                    .position(x: uvTooltipPosition.x, y: uvTooltipPosition.y - 40)
                            }
                        }
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
            Button("View Plant Details") {
                showPlantDetailsView = true
            }
            Button("Add Device to Plant") {
                showAddDeviceView = true
            }
            Button("Remove Plant") {
                showDeletePlantView = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showPlantDetailsView) {
            PlantDetailsView(plant: viewModel.plant)
        }
        .sheet(isPresented: $showAddDeviceView) {
            AddDeviceView { newDevice in
                viewModel.loadData()
            }.environmentObject(viewModel)
        }
        .alert(isPresented: $showDeletePlantView) {
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
    
    // Helper function to find the closest reading
    private func findClosestReading(to date: Date) -> Reading? {
        return viewModel.readings.min(by: { abs($0.createdAt.timeIntervalSince(date)) < abs($1.createdAt.timeIntervalSince(date)) })
    }
}

// Tooltip for temperature, humidity, and light
struct TooltipView: View {
    let reading: Reading
    let valueKey: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(formattedDate(reading.createdAt))
                .font(.caption)
                .foregroundColor(.white)
            Text(valueText)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(5)
        .background(Color.black.opacity(0.7))
        .cornerRadius(5)
    }
    
    private var valueText: String {
        switch valueKey {
        case "temperature":
            return String(format: "Temp: %.0f°F", reading.temperature)
        case "humidity":
            return String(format: "Humidity: %.0f%%", reading.humidity)
        case "lux":
            return String(format: "Light: %.0f lux", reading.lux ?? 0.0)
        default:
            return ""
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

// Tooltip for UV readings
struct UVTooltipView: View {
    let reading: Reading
    
    var body: some View {
        VStack(spacing: 2) {
            Text(formattedDate(reading.createdAt))
                .font(.caption)
                .foregroundColor(.white)
            Text(String(format: "UV A: %.1f", reading.uvA))
                .font(.headline)
                .foregroundColor(.white)
            Text(String(format: "UV B: %.1f", reading.uvB))
                .font(.headline)
                .foregroundColor(.white)
            Text(String(format: "UV C: %.1f", reading.uvC))
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(5)
        .background(Color.black.opacity(0.7))
        .cornerRadius(5)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

// Plant Details View
struct PlantDetailsView: View {
    private var plant: Plant
    init(plant: Plant) {
        self.plant = plant
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Plant Basic Information
                Group {
                    Text("Plant Name: \(plant.plantName)")
                    Text("Type: \(plant.plantType.scientificName)")
                    Text("Common Name: \(plant.plantType.commonName)")
                    Text("Family: \(plant.plantType.family)")
                }
                .font(.headline)

                // Plant Details
                Group {
                    Text("Description: \(plant.plantType.description)")
                    Text("Watering: \(plant.plantType.watering)")
                    Text("Lighting: \(plant.plantType.lighting)")
                    Text("Area: \(plant.area?.name ?? "No Area")")
                    Text("Date Planted: \(plant.datePlanted ?? "Unknown")")
                }
                .font(.subheadline)
            }
            .padding()
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
