//
//  DevicesView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/30/24.
//

import SwiftUI

struct DevicesView: View {
    @EnvironmentObject var profile: Profile
    @StateObject var viewModel = DevicesViewModel()
    @State private var showingAddDevice = false
    
    var body: some View {
        NavigationStack {
            List (viewModel.devices, id: \.id) { device in
                NavigationLink(destination: DeviceInfoView(device: device)) {
                    Text(device.deviceUUID)
                }
            }
            .refreshable {
                viewModel.loadData()
            }
            .navigationTitle("My Devices")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: DeviceRegistrationView()) {
                        Image(systemName: "plus")
                            .padding()
                    }
                }
            }
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
