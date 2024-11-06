//
//  AreaSectionView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/29/24.
//

import SwiftUI

struct AreaSectionView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let area: Area
    let areas: [Area]
    let plants: [Plant]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Section Header with NavigationLink
            HStack {
                NavigationLink(
                    destination: AreaView(area: area, plants: plants)
                ) {
                    Text(area.name)
                        .font(.title2)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .bold()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(colorScheme == .light ? .gray.opacity(0.2) : .white)
                }
            }
            .padding()

            // Horizontal Scroll View of Plants
            HorizontalPlantScrollView(plants: plants, areas: areas)
        }
    }
}

