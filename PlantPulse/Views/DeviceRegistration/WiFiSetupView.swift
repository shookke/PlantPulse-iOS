//
//  WiFiSetupView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/9/24.
//

import SwiftUI
import ESPProvision

struct WiFiSetupView: View {
    @EnvironmentObject var viewModel: DevicesViewModel
    @State private var selectedSSID: String?
    @State private var wifiPassword = ""
    @State private var isPasswordSheetPresented: Bool = false
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            if viewModel.isConnecting {
                Text("Connecting Device to WiFi")
                ProgressView()
            }
            if let error = viewModel.connectionError {
                Text(error)
                    .foregroundColor(.red)
            }
            if viewModel.wifiNetworks.isEmpty {
                Text("Searching For Available Networks")
                ProgressView()
            }
            else {
                List(viewModel.wifiNetworks, id: \.ssid) { network in
                    HStack {
                        WiFiSignalView(rssi: network.rssi)
                        Button(network.ssid) {
                            selectedSSID = network.ssid
                            isPasswordSheetPresented = true
                        }
                        .foregroundColor(.green)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchWifiNetworks()
        }
        .onDisappear {
            viewModel.wifiNetworks = []
            viewModel.device?.disconnect()
            viewModel.device = nil
        }
        .onChange(of: viewModel.isConnected) { isConnected in
            if isConnected {
                viewModel.isConnecting = false
                // Append the destination to the navigationPath
                DispatchQueue.main.async {
                    navigationPath.append(DevicesViewDestination.deviceRegistrationCompletion)
                }
            }
        }
        .sheet(isPresented: $isPasswordSheetPresented) {
            PasswordInputView(
                selectedSSID: $selectedSSID,
                wifiPassword: $wifiPassword,
                sheet: $isPasswordSheetPresented,
                navigationPath: $navigationPath,
                onConnect: {
                    viewModel.isConnecting  = true
                    Task(priority: .userInitiated) {
                        do {
                            try await viewModel.registerDevice()
                        } catch {
                            print("Error registering the device.")
                        }
                    }
                    if let ssid = selectedSSID {
                        viewModel.provisionDevice(ssid: ssid, passphrase: wifiPassword)
                    }
                    // Reset the inputs
                    selectedSSID = nil
                    wifiPassword = ""
                    isPasswordSheetPresented = false
            })
        }
    }
}

struct PasswordInputView: View {
    @Binding var selectedSSID: String?
    @Binding var wifiPassword: String
    @Binding var sheet: Bool
    @Binding var navigationPath: NavigationPath
    
    var onConnect: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Wi-Fi Password for \(selectedSSID ?? "")")
                .font(.headline)
            
            SecureField("Password", text: $wifiPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                onConnect()
            }) {
                Text("Connect")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Button("Cancel") {
                selectedSSID = nil
                wifiPassword = ""
                sheet = false
            }
            .foregroundColor(.red)
        }
        .padding()
        .presentationDetents([.medium])
    }
}

struct WiFiSetupView_Previews: PreviewProvider {
    @State static var testDevice: ESPDevice? = ESPDevice(name: "PROV_76D214", security: .secure, transport: .ble, proofOfPossession: "abcd1234")
    
    @State static var navigationPath = NavigationPath()
    
    static var previews: some View {
        WiFiSetupView(navigationPath: $navigationPath)
            .environmentObject(DevicesViewModel())
    }
}
