//
//  QRScannerView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/30/24.
//

import SwiftUI
import UIKit
import ESPProvision

struct QRScannerView: View {
    @EnvironmentObject var viewModel: DeviceRegistrationViewModel
    @State private var deviceConnected = false
    @State private var isPresentingScanner = false
    @State private var connectionError: String? = nil
    @State private var testImage: UIImage? = nil

    var body: some View {
            VStack {
                if let device = viewModel.device {
                    Text("Device Scanned: \(device.name)")
                    Image(systemName: "circle.dotted")
                        .onAppear {

                            do {
                                connectToDevice(device: device, mode: "test")
                            }
                        }
                } else {
                    Text("Scan Device QR code")
                    Button("Test with QR Image") {
                        testImage = UIImage(named: "ProvisioningQRCode") // Replace with your test image
                        isPresentingScanner.toggle()
                    }
                }
            }
            .sheet(isPresented: $isPresentingScanner, content: {
                if let testImage = testImage {
                    // Simulated QR code scanning for testing in simulator or preview
                    QRCodeScannerTestView(
                        testImage: testImage,
                        onDeviceScanned: { device in
                            viewModel.device = device
                            isPresentingScanner = false
                        }
                    )
                } else {
                    QRCodeScannerView(
                        page: self,
                        onDeviceScanned: { device in
                            viewModel.device = device
                            isPresentingScanner = false
                        },
                        previewLayerView: UIView() // Replace with custom UIView if necessary
                    )
                }
            })
            .onAppear {
                // Automatically trigger the scanner when the view appears
                isPresentingScanner = true
            }
            .navigationDestination(isPresented: $deviceConnected) {
                WiFiSetupView()
                    .environmentObject(viewModel)
            }
    }
    // Function to handle device connection and navigate on success
    private func connectToDevice(device: ESPDevice, mode: String?) {
        switch mode {
            case "test":
                deviceConnected = true
            default:
                device.connect { result in
                    switch result {
                    case .connected:
                        print("Device connected successfully.")
                        deviceConnected = true
                    case .failedToConnect(let error):
                        print("Failed to connect to the device: \(error.localizedDescription)")
                        // Handle failure if needed
                    case .disconnected:
                        print("Device disconnected")
                    }
                }
        }
    }
}

extension QRScannerView: ESPDeviceConnectionDelegate {
    func getProofOfPossesion(forDevice: ESPDevice, completionHandler: @escaping (String) -> Void) {
        let pop = "abc123"
        completionHandler(pop)
    }
    
    func getUsername(forDevice: ESPDevice, completionHandler: @escaping (_ username: String?) -> Void) {
        let username = "test"
        completionHandler(username)
    }
}

struct QRCodeScannerTestView: View {
    var testImage: UIImage
    var onDeviceScanned: (ESPDevice) -> Void

    var body: some View {
        VStack {
            Text("Simulated QR Code Scanning")
            Image(uiImage: testImage)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onAppear {
                    simulateScanningQRCode(image: testImage)
                }
        }
    }

    func simulateScanningQRCode(image: UIImage) {
        // Here we simulate the QR code scanning process
        // This is where you would handle the image processing, e.g., using a QR code library
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Simulating successful device scan after processing the image
            let mockDevice = ESPDevice(name: "PROV_76D214", security: .secure, transport: .ble, proofOfPossession: "abcd1234")
            onDeviceScanned(mockDevice)
        }
    }
}

//struct QRScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        QRScannerView()
//    }
//}
