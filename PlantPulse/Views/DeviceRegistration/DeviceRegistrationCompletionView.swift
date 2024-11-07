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
                    viewModel.reset()
                    navigationPath = NavigationPath()
                } else {
                    print("Registering device")
                    Task(priority: .userInitiated) {
                        try await viewModel.registerDevice()
                        isDone = true
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
                    viewModel.reset()
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

