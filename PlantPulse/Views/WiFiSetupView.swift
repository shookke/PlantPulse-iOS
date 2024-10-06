//
//  WiFiSetupView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/9/24.
//

import SwiftUI
import ESPProvision

struct WiFiSetupView: View {
    @EnvironmentObject var viewModel: DeviceRegistrationViewModel
    @State private var selectedSSID: String?
    @State private var wifiPassword = ""
    @State private var isPasswordSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            List(viewModel.wifiNetworks, id: \.ssid) { network in
                HStack {
                    if let error = viewModel.connectionError {
                        Text(error)
                            .foregroundColor(.red)
                    }
                    WiFiSignalView(rssi: network.rssi)
                    Button(network.ssid) {
                        selectedSSID = network.ssid
                        isPasswordSheetPresented = true
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
            NavigationLink(destination: PlantIDView()){
                Text("Proceed to Plant Identification.")
            }
        }
        .onAppear {
            viewModel.fetchWifiNetworks()
        }
        .sheet(isPresented: $isPasswordSheetPresented) {
            PasswordInputView(
                selectedSSID: $selectedSSID,
                wifiPassword: $wifiPassword,
                sheet: $isPasswordSheetPresented,
                onConnect: {
                if let ssid = selectedSSID {
                    viewModel.provisionDevice(ssid: ssid, passphrase: wifiPassword)
                }
                // Reset the inputs
                selectedSSID = nil
                wifiPassword = ""
                isPasswordSheetPresented = false
            })
        }
        .navigationDestination(isPresented: $viewModel.isConnected) {
            PlantIDView()  // Next view in the setup process
        }
    }
}

struct PasswordInputView: View {
    @Binding var selectedSSID: String?
    @Binding var wifiPassword: String
    @Binding var sheet: Bool
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
    
    static var previews: some View {
        WiFiSetupView()
            .environmentObject(DeviceRegistrationViewModel())
    }
}
