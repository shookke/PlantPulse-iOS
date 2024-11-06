//
//  PlantIdView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/10/24.
//

import SwiftUI

struct PlantIDView: View {
    @EnvironmentObject var viewModel: DevicesViewModel

    @State private var showAddPlantView = false
    
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            Button(action: {
                showAddPlantView = true
            }) {
                Text("Add Plant")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .background(Color.green)
            .padding(.vertical)
            Button("Skip") {
                navigationPath.append(DevicesViewDestination.deviceRegistrationCompletion)
            }
        }
        .onChange(of: showAddPlantView) { newValue in
            if !newValue {
                // Sheet was dismissed
                navigationPath.append(DevicesViewDestination.deviceRegistrationCompletion)
            }
        }
        .sheet(isPresented: $showAddPlantView) {
            AddPlantView { newPlant in
                viewModel.loadData()
                showAddPlantView = false
            }
            
        }
    }
}
