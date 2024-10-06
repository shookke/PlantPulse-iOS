//
//  WeatherResponse.swift
//  PlantPulse
//
//  Created by Kevin Shook on 10/27/24.
//

import Foundation

struct WeatherResponse: Decodable {
    let current: CurrentWeather?
    let daily: [DailyWeather]
    let hourly: [HourlyWeather]
    let timezone: String
    let timezone_offset: Int
}

struct CurrentWeather: Decodable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let weather: [Weather]
}


struct DailyWeather: Decodable {
    let dt: Int
    let temp: Temperature
    let weather: [Weather]
}

struct HourlyWeather: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Temperature: Decodable {
    let day: Double
    let min: Double
    let max: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
