//
//  WiFiSignalView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/10/24.
//

import SwiftUI

struct WiFiSignalView: View {
    let rssi: Int32
    
    var body: some View {
            let normalizedRSSI = min(max(Double(rssi + 100) / 60.0, 0.0), 1.0)  // Normalize rssi between 0 and 1
            return Image(systemName: rssi > -100 ? "wifi" : "wifi.slash", variableValue: normalizedRSSI)
                .foregroundColor(signalColor(for: Double(rssi)))
        }
    
    // Optional: Different colors for signal strength
    func signalColor(for rssi: Double) -> Color {
        switch rssi {
        case (-50)...:
            return .green // Excellent
        case (-70)...:
            return .yellow // Good
        case (-80)...:
            return .orange // Fair
        default:
            return .red // Weak
        }
    }
}

struct WiFiSignalView_Previews: PreviewProvider {
    static var previews: some View {
        WiFiSignalView(rssi: Int32(-60)) // Example RSSI value
    }
}



