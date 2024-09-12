//
//  WiFiSignalView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/10/24.
//

import SwiftUI

struct WiFiSignalView: View {
    let rssi: Int32
    
    // Function to map RSSI value to SF Symbols
    func wifiSymbol(for rssi: Int32) -> String {
        switch rssi {
        case (-50)...:
            return "wifi" // Excellent signal
        case (-70)...:
            return "wifi" // Good signal
        case (-80)...:
            return "wifi" // Fair signal
        case ..<(-80):
            return "wifi.exclamationmark" // Weak signal or no connection
        default:
            return "wifi.slash" // No signal
        }
    }
    
    var body: some View {
        Image(systemName: wifiSymbol(for: rssi))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundColor(signalColor(for: rssi))
    }
    
    // Optional: Different colors for signal strength
    func signalColor(for rssi: Int32) -> Color {
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



