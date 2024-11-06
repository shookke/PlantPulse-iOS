//
//  DeviceRegistrationCompletionView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/23/24.
//

import SwiftUI

struct DeviceRegistrationCompletionView: View {
    @EnvironmentObject var viewModel: DevicesViewModel
    @Binding var navigationPath: NavigationPath
    
    @State private var isDone = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Device has been successfully registered!")
                .font(.headline)
            
            Button(action: {
                if viewModel.isDeviceCreated {
                    viewModel.device?.disconnect()
                    viewModel.device = nil
                    navigationPath = NavigationPath()
                } else {
                    isDone = true
                    Task {
                        try await viewModel.registerDevice()
                    }
                }
            }) {
                Text("Disconnect and Finish")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .onReceive(viewModel.$isDeviceCreated) { isReady in
                if isReady && isDone {
                    viewModel.device?.disconnect()
                    viewModel.device = nil
                    navigationPath = NavigationPath()
                }
            }
        }
        .padding()
    }
}

#Preview {
    @State var navigationPath = NavigationPath()
    DeviceRegistrationCompletionView(navigationPath: $navigationPath)
        .environmentObject(DevicesViewModel());
}

