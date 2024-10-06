//
//  PlantTypeSelectionView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import SwiftUI

struct PlantTypeSelectionView: View {
    @Binding var selectedPlantType: PlantType?
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var plantTypeManager = PlantTypeManager()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(plantTypeManager.plantTypes) { plantType in
                    Button(action: {
                        selectedPlantType = plantType
                        dismiss()
                    }) {
                        HStack {
                            if let imageURLString = plantType.image,
                               let url = URL(string: imageURLString) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipped()
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipped()
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                            }
                            VStack(alignment: .leading) {
                                Text(plantType.commonName)
                                    .font(.headline)
                                Text(plantType.scientificName)
                                    .font(.subheadline)
                                    .italic()
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                // Loading Indicator
                if plantTypeManager.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Loading...")
                        Spacer()
                    }
                }
                
                // Load More Button
                if plantTypeManager.canLoadMore && !plantTypeManager.isLoading {
                    Button("Load More") {
                        Task {
                            await plantTypeManager.loadMorePlantTypes()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Select Plant Type")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Plant Types")
            .onChange(of: searchText) { newValue in
                Task {
                    plantTypeManager.searchQuery = newValue
                    await plantTypeManager.resetAndLoadPlantTypes()
                }
            }
            .onAppear {
                if plantTypeManager.plantTypes.isEmpty {
                    Task {
                        await plantTypeManager.loadMorePlantTypes()
                    }
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { plantTypeManager.errorMessage != nil },
                set: { _ in plantTypeManager.errorMessage = nil }
            )) {
                Alert(title: Text("Error"),
                      message: Text(plantTypeManager.errorMessage ?? "An unknown error occurred."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
