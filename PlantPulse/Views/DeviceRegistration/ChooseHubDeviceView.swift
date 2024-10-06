//
//  ChooseHubDeviceView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/30/24.
//

import SwiftUI

struct ChooseHubDeviceView: View {
    @EnvironmentObject var viewModel: DevicesViewModel
    @State var selectedDeviceId: String? = ""
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            Picker("Select a Camera Device", selection: $selectedDeviceId) {
                ForEach(viewModel.devices.filter { $0.deviceType == "camera" }) { device in
                    Text(device.deviceUUID).tag(device.id as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .onChange(of: selectedDeviceId) { newValue in
                if let id = newValue {
                    viewModel.deviceToConnect = id
                }
            }
            Button(action: {
                // Assign the selected device ID to the registrationViewModel
                if let selectedId = selectedDeviceId {
                    viewModel.deviceToConnect = selectedId
                    Task {
                        try await viewModel.registerDevice()
                    }
                }
                // Navigate to DeviceRegistrationCompletionView
                navigationPath.append(DevicesViewDestination.deviceRegistrationCompletion)
            }) {
                Text("Confirm Selection")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedDeviceId != nil ? Color.green : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(selectedDeviceId == nil)
            .padding(.horizontal)
        }
    }
}
