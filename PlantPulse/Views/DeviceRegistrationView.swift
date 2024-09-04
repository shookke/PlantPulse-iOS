//
//  DeviceRegistrationView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/30/24.
//

import SwiftUI
import ESPProvision

struct DeviceRegistrationView: View {
    @StateObject private var viewModel = DeviceRegistrationViewModel()
    
    var body: some View {
        NavigationStack {
            QRScannerView()
        }
    }
}

struct DeviceRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceRegistrationView()
    }
}
