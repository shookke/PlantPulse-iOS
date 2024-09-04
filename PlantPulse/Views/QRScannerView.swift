//
//  QRScannerView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/30/24.
//

import SwiftUI

struct QRScannerView: View {
    var body: some View {
        QRCodeScannerView(onDeviceScanned: { device in
            // Handle ESPDevice after scanning
            print("Device Scanned: \(device)")
        }, previewLayerView: UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400)))
    }
}

struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRScannerView()
    }
}
