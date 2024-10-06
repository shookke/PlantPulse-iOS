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
                        connectToDevice(device: device)
                    }
            } else {
                Button(action:{
                    isPresentingScanner = true
                }) {
                    Text("Scan Device QR code")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .sheet(isPresented: $isPresentingScanner, content: {
            QRCodeScannerView { result in
                switch result {
                case .success(let device):
                    viewModel.device = device
                    isPresentingScanner = false
                case .failure(let error):
                    connectionError = error.localizedDescription
                    isPresentingScanner = false
                }
            }
        })
        .navigationDestination(isPresented: $deviceConnected) {
            WiFiSetupView()
                .environmentObject(viewModel)
        }
    }

    private func connectToDevice(device: ESPDevice) {
        device.connect { result in
            switch result {
            case .connected:
                print("Device connected successfully.")
                deviceConnected = true
            case .failedToConnect(let error):
                print("Failed to connect to the device: \(error.localizedDescription)")
            case .disconnected:
                print("Device disconnected")
            }
        }
    }
}

struct QRCodeScannerView: UIViewControllerRepresentable {
    var completionHandler: (Result<ESPDevice, Error>) -> Void

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let scannerVC = QRScannerViewController()
        scannerVC.completionHandler = completionHandler
        return scannerVC
    }

    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {}
}

class QRScannerViewController: UIViewController {
    var completionHandler: ((Result<ESPDevice, Error>) -> Void)?

    // Connection status label
    private var statusLabel: UILabel?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStatusLabel()
        startScanning()
    }

    private func startScanning() {
        ESPProvisionManager.shared.scanQRCode(scanView: view) { device, error in
            if let device = device {
                self.completionHandler?(.success(device))
            } else if let error = error {
                self.completionHandler?(.failure(error))
            }
        } scanStatus: { status in
            print("Scan status: \(status)")
        }
    }
    
    private func setupStatusLabel() {
        // Create and configure the status label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Scanning for device..."

        // Add the label to the main view
        view.addSubview(label)
        self.statusLabel = label

        // Set constraints to position the label at the bottom of the screen
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Ensure the label is on top of all other views
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.bringSubviewToFront(label)
        }
    }

    // Update the status label to show the connection message upon successful QR scan
    private func updateStatusLabelForSuccess() {
        DispatchQueue.main.async {
            self.statusLabel?.text = "Device found. Attempting to connect..."
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ESPProvisionManager.shared.stopScan()
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
