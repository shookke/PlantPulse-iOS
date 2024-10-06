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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Device has been successfully registered!")
                .font(.headline)
            
            Button(action: {
                viewModel.device?.disconnect()
                viewModel.device = nil
                navigationPath = NavigationPath()
            }) {
                Text("Disconnect and Finish")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
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

