//
//  QRScannerViewModel.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/30/24.
//
import SwiftUI
import UIKit
import ESPProvision

struct QRCodeScannerView<Page: View>: UIViewControllerRepresentable {
    var page: Page
    
// Callback to return the ESPDevice on success
    var onDeviceScanned: (ESPDevice) -> Void
    
    // UIView where the camera preview will be displayed
    var previewLayerView: UIView
    
    func makeUIViewController(context: Context) -> QRCodeScannerViewController {
        return QRCodeScannerViewController(onDeviceScanned: onDeviceScanned, previewLayerView: previewLayerView)
    }

    func updateUIViewController(_ uiViewController: QRCodeScannerViewController, context: Context) {
        // No updates needed for now
    }
}

class QRCodeScannerViewController: UIViewController {
    
    var previewLayerView: UIView
    var onDeviceScanned: (ESPDevice) -> Void
    
    init(onDeviceScanned: @escaping (ESPDevice) -> Void, previewLayerView: UIView) {
        self.onDeviceScanned = onDeviceScanned
        self.previewLayerView = previewLayerView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning for QR code using ESPProvisionManager
        ESPProvisionManager.shared.scanQRCode(scanView: previewLayerView) { [weak self] device, error in
            if let device = device {
                self?.onDeviceScanned(device)
            } else if let error = error {
                print("Error scanning QR code: \(error.localizedDescription)")
            }
        }
    }
}
