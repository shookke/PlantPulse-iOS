//
//  SettingsView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/24/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Spacer()
            Button(action: {
                profile.signOut()
            }) {
                Text("Sign Out")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
