//
//  PlantIdView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/10/24.
//

import SwiftUI

struct PlantIDView: View {
    @EnvironmentObject var registrationViewModel: DevicesViewModel
    @StateObject var viewModel = PlantIDViewModel()
    @State private var isAnimating = false
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            Image(systemName: "leaf.fill")
                .foregroundColor(.green)
            Text("Please Select the plant type you wish to monitor.")
                .padding()

            // Loading State
            if viewModel.isLoading {
                VStack {
                    Text("Loading Plant Types...")
                    ProgressView()
                }
            } else {
                // Plant List
                List(viewModel.plantsList) { (plant: PlantType) in
                    Button(action: {
                        viewModel.plantTypeId = plant.id
                    }) {
                        HStack {
                            // Safely unwrap and display the image
                            if let imageURL = URL(string: plant.image ?? "") {
                                AsyncImage(url: imageURL)
                                    .frame(width: 50, height: 50)
                            }
                            VStack(alignment: .leading) {
                                Text(plant.commonName)
                                    .font(.headline)
                                Text(plant.scientificName)
                                    .font(.subheadline)
                                    .fontWeight(.ultraLight)
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            viewModel.loadData()
        }
        NavigationLink(destination: DeviceRegistrationCompletionView(navigationPath: $navigationPath)){
            Text("Skip plant setup.");
        }
    }
}
