//
//  WiFiSetupViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/9/24.
//

import SwiftUI
import ESPProvision

class WiFiSetupViewModel: ObservableObject {
    @Published var wifiNetworks: [ESPWifiNetwork] = []
    @Published var connectionError: String?
    @Published var isConnected = false
    @Published var isConfigApplied = false
    
    private var device: ESPDevice?
    
    init(device: ESPDevice?) {
        self.device = device
    }
    
    func fetchWifiNetworks() {
        print("Fetching Wifi Networks.")
        device?.scanWifiList { [weak self] wifiList, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.connectionError = error.localizedDescription
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.wifiNetworks = wifiList ?? []
            }
        }
    }
    
    func provisionDevice(ssid: String, passphrase: String) {
        device?.provision(ssid: ssid, passPhrase: passphrase) { [weak self] status in
            switch status {
            case .success:
                DispatchQueue.main.async {
                    self?.isConnected = true
                }
            case .configApplied:
                DispatchQueue.main.async {
                    self?.isConfigApplied = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.connectionError = error.localizedDescription
                }
            }
        }
    }
}



