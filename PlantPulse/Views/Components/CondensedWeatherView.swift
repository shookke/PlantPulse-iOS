//
//  CondensedWeatherView.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/28/24.
//
import SwiftUI

struct CondensedWeatherView: View {
    let currentWeather: CurrentWeather
    @State private var animateBounce = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Weather Icon
            Image(systemName: weatherSymbol)
                .renderingMode(.original) // Use multicolor rendering
                .font(.system(size: 50))
                .offset(y: animateBounce ? 0 : -20)
                .animation(
                    Animation.interpolatingSpring(stiffness: 300, damping: 15),
                    value: animateBounce
                )
                .onAppear {
                    animateBounce = true
                }

            VStack(alignment: .leading) {
                // Weather Description
                Text(currentWeather.weather.first?.description.capitalized ?? "")
                    .font(.subheadline)
                // Temperature
                Text("\(Int(currentWeather.temp))°")
                    .font(.title)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.brown).opacity(0.1)
        )
        .padding(.horizontal)
    }

    // Computed Property for Weather Symbol
    private var weatherSymbol: String {
        let conditionId = currentWeather.weather.first?.id ?? 0
        let isDay = isDaytime(
            currentTime: currentWeather.dt,
            sunrise: currentWeather.sunrise,
            sunset: currentWeather.sunset
        )
        return getWeatherSymbol(for: conditionId, isDaytime: isDay)
    }
    
    // Weather Symbol selector
    func getWeatherSymbol(for conditionId: Int, isDaytime: Bool) -> String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain.fill" // Thunderstorm
        case 300...321:
            return "cloud.drizzle.fill" // Drizzle
        case 500...531:
            return "cloud.rain.fill" // Rain
        case 600...622:
            return "cloud.snow.fill" // Snow
        case 701...781:
            return "cloud.fog.fill" // Atmosphere (fog, mist, etc.)
        case 800:
            return isDaytime ? "sun.max.fill" : "moon.stars.fill" // Clear
        case 801...804:
            return "cloud.fill" // Clouds
        default:
            return "questionmark.circle" // Unknown
        }
    }
    
    // Day or Night
    func isDaytime(currentTime: Int, sunrise: Int, sunset: Int) -> Bool {
        return currentTime >= sunrise && currentTime < sunset
    }
}
