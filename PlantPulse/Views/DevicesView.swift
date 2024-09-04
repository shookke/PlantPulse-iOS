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
            List {
                ForEach(viewModel.devices) { device in
                    Text(device.plantType)
                }
            }
            .refreshable {
                viewModel.loadData()
            }
            .navigationTitle("My Devices")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddDevice = true
                    }) {
                        Image(systemName: "plus")
                            .padding()
                    }
                }
            }
            .navigationDestination(isPresented: $showingAddDevice) {
                DeviceRegistrationView()
            }
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
