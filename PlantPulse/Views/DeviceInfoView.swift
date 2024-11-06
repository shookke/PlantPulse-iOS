//
//  DeviceInfoView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/9/24.
//

import SwiftUI

struct DeviceInfoView: View {
    @StateObject var viewModel = DeviceInfoViewModel()
    @State var showingOptions = false
    @State var showRemoveDeviceView = false
    @State var isDeleted = false
    @State var device: Device
    @State private var errorMessage: String?
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline){
                Text("Status: ")
                    .font(.title2)
                Image(systemName: setBatterySymbol(batteryLevel: device.batteryLevel))
                    .font(.title2)
            }
            .padding(.horizontal)
            Text("Connected Device:")
                .font(.title2)
                .padding(.horizontal)
            List(device.connectedDevices.compactMap { $0 }) { (device: Device) in
                HStack{
                    Text(device.deviceUUID)
                        .font(.title)
                        
                    Spacer()
                    Image(systemName: setBatterySymbol(batteryLevel: device.batteryLevel))
                }
                if device.plants.isEmpty {
                    EmptyView()
                } else {
                    ForEach(device.plants.compactMap { $0 }) { (plant: Plant) in
                        Text("Plant Sensor is Monitoring")
                            .fontWeight(.bold)
                        HStack {
                            Text("Name:")
                            Text(plant.plantName)
                                .font(.title2)
                        }
                        HStack {
                            Text("Common Name:")
                                .fontWeight(.bold)
                            Text(plant.plantType.commonName)
                                .font(.subheadline)
                        }
                        HStack {
                            Text("Classification:")
                                .fontWeight(.bold)
                            Text(plant.plantType.scientificName)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .navigationTitle(device.deviceUUID)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingOptions = true
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.secondary, .green.opacity(0.25))
                }
            }
        }
        .onChange(of: isDeleted) { isDeleted in
            if isDeleted {
                navigationPath = NavigationPath()
            }
        }
        .confirmationDialog("Options", isPresented: $showingOptions, titleVisibility: .hidden) {
            Button("Remove Device") {
                showRemoveDeviceView = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert(isPresented: $showRemoveDeviceView) {
            Alert(
                title: Text("Remove Device"),
                message: Text("Are you sure you want to remove this device? This action cannot be undone."),
                primaryButton: .destructive(Text("Remove")) {
                    removeDevice()
                    isDeleted = true
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func setBatterySymbol (batteryLevel: Double?) -> String {
        guard let batteryLevel = batteryLevel else { return "battery.0percent"; }
        switch batteryLevel {
        case 0.75...:
            return "battery.100percent";
        case 0.50...:
            return "battery.75percent";
        case 0.25...:
            return "battery.50percent";
        case 0.0...:
            return "battery.0percent";
        default:
            return "batter.100percent.bolt";
        }
    }
    
    func removeDevice() {
        print("Device has been removed.")
        Task {
            let result = await viewModel.removeDevice(device: self.device)
            if result {
                
            } else {
                self.errorMessage = viewModel.errorMessage
            }
        }
    }
}
