//
//  ChooseHubDeviceView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/30/24.
//

import SwiftUI

struct ChooseHubDeviceView: View {
    @EnvironmentObject var viewModel: DevicesViewModel
    @State var selectedDeviceId: String? = nil
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            Picker("Select a Camera Device", selection: $selectedDeviceId) {
                Text("None").tag(nil as String?)
                ForEach(viewModel.devices.filter { $0.deviceType == "camera" }) { device in
                    Text(device.deviceUUID).tag(device.id as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .onDisappear {
                viewModel.device?.disconnect()
                viewModel.device = nil
            }
            Button(action: {
                // Assign the selected device ID to the registrationViewModel
                if let selectedId = selectedDeviceId {
                    viewModel.deviceToConnect = selectedId
                }
                // Navigate to DeviceRegistrationCompletionView
                navigationPath.append(DevicesViewDestination.plantId)
            }) {
                Text("Confirm Selection")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
    }
}
