//
//  PlantIdView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 9/10/24.
//

import SwiftUI

struct PlantIDView: View {
    @StateObject var viewModel = PlantIDViewModel()
    @State private var isAnimating = false
    
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
                    Image(systemName: "arrow.2.circlepath")
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                        .onDisappear {
                            isAnimating = false
                        }
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
                                    .clipShape(Circle())
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
    }
}
