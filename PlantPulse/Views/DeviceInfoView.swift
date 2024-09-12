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
            List(device.plants) { plant in
                Text(plant.plantType.name)
            }
            List(device.connectedDevices) { connectedDevice  in
                Text(connectedDevice.deviceUUID)
            }
        }
    }
}

struct DeviceInfoView_Previews: PreviewProvider {
    static var testDevice = Device(id: "12344", deviceUUID: "123456", connectedDevices: [], plants: [], user: "123", createdAt: "123", updatedAt: "123")
    static var previews: some View {
        DeviceInfoView(device: testDevice)
    }
}
