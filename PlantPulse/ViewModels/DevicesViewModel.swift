//
//  DevicesViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/31/24.
//

import Foundation
import SwiftUI
import ESPProvision

class DevicesViewModel: ObservableObject {
    @Published var device: ESPDevice?
    @Published var devices: [Device] = []
    @Published var deviceLoadError: String? = ""
    @Published var wifiNetworks: [ESPWifiNetwork] = []
    @Published var deviceType: String = ""
    @Published var deviceData = Data()
    @Published var deviceToConnect: String = ""
    @Published var plant: String? = nil
    @Published var plantType: String? = nil
    @Published var plantName = ""
    @Published var datePlanted: String?
    @Published var dateHarvested: String?
    @Published var lastFertilization: String?
    @Published var selectedPlantType: PlantType?
    @Published var isCreatingPlant = false
    @Published var isPlantCreated = false
    @Published var connectionError: String? = nil
    @Published var isConnecting = false
    @Published var isConnected = false
    @Published var isConfigApplied = false
    @Published var errorMessage: String? = nil
    @Published var isDeviceCreated = false
    
    init() {
        loadData()
    }
    
    func fetchWifiNetworks() {
        device?.scanWifiList() { [weak self] wifiList, error in
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
        Task {
           try await registerDevice()
        }
    }
    
    @MainActor
    func createPlant() async {
        // Make Sure there is a selected PlantType
        guard let plantType = selectedPlantType else { return }
        
        // Set Statuses
        isCreatingPlant = true
        errorMessage = nil
        
        do {
            // Prepare the request
            guard let url = URL(string: "\(NetworkConstants.baseURL)/plants/") else {
                throw APIError.invalidURL
            }
            
            let newPlantData: [String: Any] = [
                "plant": [
                    "plantType": plantType.id,
                    "container": nil,
                    "area": nil,
                    "plantName": plantName,
                    "datePlanted": datePlanted,
                    "dateHarvested": dateHarvested,
                    "lastFertilization": lastFertilization
                ]
            ]
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "POST", body: newPlantData)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 201 else { throw APIError.serverError }
            
            guard let data = try? JSONDecoder().decode(Plant.self, from: data) else { throw APIError.noData }
            
            plant = data.id
            
        } catch (let error) {
            errorMessage = error.localizedDescription
        }
        // Update status
        isPlantCreated = true
        isCreatingPlant = false
    }

    @MainActor
    func registerDevice() async throws {
        if let device = device {
            do {
                guard let url = URL(string: "\(NetworkConstants.baseURL)/devices/") else {
                    throw APIError.invalidURL
                }
                
                var registrationData: [String: Any] = [
                    "device": [
                        "deviceUUID": device.name,
                        "deviceType": deviceType
                    ]
                ]
                if deviceType == "sensor" {
                    guard let plantTypeId = selectedPlantType?.id else { throw APIError.custom("PlantType Missing")}
                    registrationData["connectTo"] = deviceToConnect
                    registrationData["plantId"] = plant
                }
                
                let request = try APIHelper.shared.formatRequest(url: url, method: "POST", body: registrationData)
                
                // Create and run the URLSession
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // Validate the response
                guard (response as? HTTPURLResponse)?.statusCode == 201 else { throw APIError.serverError }
                
                let createdDevice = try JSONDecoder().decode(NewDeviceResponse.self, from: data)
                
                if (createdDevice.device.deviceType == "camera") {
                    do {
                        let payload: [String: String] = [
                            "token": createdDevice.token,
                            "deviceId": createdDevice.device.id
                        ]
                        
                        let encodedData = try JSONEncoder().encode(payload)
                        
                        self.deviceData = encodedData
                        
                    } catch {
                        print("Failed to encode device data: \(error.localizedDescription)")
                    }
                }
            } catch {
                self.connectionError = error.localizedDescription
            }
        }
        isDeviceCreated = true
    }
    
    func provisionDevice(ssid: String, passphrase: String) {
        self.isConnecting = true
        
        self.device?.provision(ssid: ssid, passPhrase: passphrase) { [weak self] status in
            switch status {
            case .success:
                self?.sendData()
                DispatchQueue.main.async {
                    self?.isConnected = true
                    self?.isConnecting = false
                }
            case .configApplied:
                DispatchQueue.main.async {
                    self?.isConfigApplied = true
                    self?.isConnecting = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.connectionError = error.localizedDescription
                    self?.isConnecting = false
                }
            }
        }
    }
    
    private func sendData(){
        self.device?.sendData(path: "custom-data", data: self.deviceData, completionHandler: { [weak self] responseData, error in
            guard let response = responseData else { return }
            print(response)
            if let error = error {
                // Handle the error
                DispatchQueue.main.async {
                    self?.connectionError = error.localizedDescription
                    self?.isConnecting = false
                }
                return
            }
        })
    }
    
}

extension DevicesViewModel {
    @MainActor
    func fetchDevices() async throws {
        do {
            guard let url = URL(string: "\(NetworkConstants.baseURL)/devices/") else {
                throw APIError.invalidURL
            }
            
            let request = try APIHelper.shared.formatRequest(url: url, method: "GET", body: nil)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.serverError }
            
            guard let data = try? JSONDecoder().decode(DevicesResponse.self, from: data) else { throw APIError.noData }

            self.devices = data.devices
            
            
        } catch {
            deviceLoadError = error.localizedDescription
        }
    }
    
    func loadData() {
        Task(priority: .medium) {
           try await fetchDevices()
        }
    }
}

