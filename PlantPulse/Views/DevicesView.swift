//
//  DevicesView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/30/24.
//

import SwiftUI

struct DevicesView: View {
    @EnvironmentObject var profile: Profile
    @StateObject var viewModel = DevicesViewModel()

    @State var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List(viewModel.devices, id: \.id) { device in
                NavigationLink(value: DevicesViewDestination.deviceDetail(device.id)) {
                    Text(device.deviceUUID)
                }
            }
            .refreshable {
                viewModel.loadData()
            }
            .task {
                viewModel.loadData()
            }
            .navigationTitle("My Devices")
            .navigationDestination(for: DevicesViewDestination.self) { destination in
                switch destination {
                case .deviceDetail(let deviceId):
                    if let device = viewModel.devices.first(where: { $0.id == deviceId }) {
                        DeviceInfoView(device: device, navigationPath: $navigationPath)
                    } else {
                        Text("Device not found")
                            .foregroundColor(.red)
                    }
                case .deviceRegistration:
                    DeviceRegistrationView(navigationPath: $navigationPath)
                case .wiFiSetup:
                    WiFiSetupView(navigationPath: $navigationPath)
                case .chooseHubDevice:
                    ChooseHubDeviceView(navigationPath: $navigationPath)
                case .plantId:
                    PlantIDView(navigationPath: $navigationPath)
                case .deviceRegistrationCompletion:
                    DeviceRegistrationCompletionView(navigationPath: $navigationPath)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        navigationPath.append(DevicesViewDestination.deviceRegistration)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.secondary, .green.opacity(0.25))
                    }
                }
            }
        }
        .environmentObject(viewModel)
    }
}


struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView().environmentObject(Profile())
    }
}
