//
//  PlantCardView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//

import SwiftUI

struct PlantCardView: View {
    let plant: Plant

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // AsyncImage to load the image from URL
            AsyncImage(url: plant.latestReading?.rgbImage) { phase in
                switch phase {
                case .empty:
                    // Placeholder while loading
                    Color.gray
                        .frame(height: 200)
                        .overlay(
                            ProgressView()
                        )
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                case .failure:
                    // Error image
                    Color.red
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(10)
            .frame(width: cardWidth)

            // Plant Name
            Text(plant.plantName)
                .font(.headline)
                .lineLimit(1)

            // Watering and Lighting Info
            Text("\(plant.plantType.watering) • \(plant.plantType.lighting)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(width: cardWidth)
    }

    // Computed property for card width
    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width * 0.4
    }
}

