//
//  HorizontalPlantScrollView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import SwiftUI

struct HorizontalPlantScrollView: View {
    let plants: [Plant]
    let areas: [Area]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(plants) { plant in
                    NavigationLink(destination: PlantInfoView(plant: plant, areas: areas)) {
                        PlantCardView(plant: plant)
                    }
                }
            }
            .padding(.horizontal, leadingPadding)
        }
        .frame(height: 230) // Adjust height as needed
    }

    // Computed property for leading padding to position cards
    private var leadingPadding: CGFloat {
        UIScreen.main.bounds.width * 0.07
    }
}
