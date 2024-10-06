//
//  DeviceInfoView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/9/24.
//

import SwiftUI

struct DeviceInfoView: View {
    var device: Device
    
    var body: some View {
        VStack{
            Text(device.deviceUUID)
            List(device.plants.compactMap { $0 }) { (plant: Plant) in
                Text(plant.plantType.commonName)
            }
            if !device.connectedDevices.isEmpty {
                List(device.connectedDevices) { (connectedDevice: Device)  in
                    Text(connectedDevice.deviceUUID)
                }
            }
        }
    }
}

