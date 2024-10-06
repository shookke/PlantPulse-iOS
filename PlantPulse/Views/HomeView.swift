//
//  HomeView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 8/24/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var profile: Profile
    @StateObject private var viewModel = HomeViewModel()

    // State variables for adding plants and areas
    @State private var showingAddOptions = false
    @State private var showAddPlantView = false
    @State private var showAddAreaView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // CondensedWeatherView at the top
                    weatherView // Use the weatherView computed property

                    // Iterate over each area
                    ForEach(viewModel.areas) { area in
                        if let plantsInArea = viewModel.areaPlants[area] {
                            AreaSectionView(area: area, plants: plantsInArea)
                        }
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                viewModel.loadData()
            }
            .navigationTitle("My Plants")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddOptions = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.secondary, .green.opacity(0.25))
                    }
                }
            }
            .confirmationDialog("Add New", isPresented: $showingAddOptions, titleVisibility: .hidden) {
                Button("Add Plant") {
                    showAddPlantView = true
                }
                Button("Add Area") {
                    showAddAreaView = true
                }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $showAddPlantView) {
                AddPlantView { newPlant in
                    viewModel.loadData()
                }
            }
            .sheet(isPresented: $showAddAreaView) {
                AddAreaView { newArea in
                    viewModel.loadData()
                    showAddAreaView = false
                }
            }
        }
    }

    @ViewBuilder
        private var weatherView: some View {
            switch viewModel.weatherViewState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView("Fetching weather data...")
                    .padding()
            case .data(let weather):
                if let currentWeather = weather.current {
                    CondensedWeatherView(currentWeather: currentWeather)
                        .padding(.horizontal)
                } else {
                    EmptyView()
                }
            case .error(let message):
                Text(message)
                    .foregroundColor(.red)
                    .padding()
            }
        }
}
