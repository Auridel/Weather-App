//
//  ApiResponse.swift
//  Weather App
//
//  Created by Олег Ефимов on 15.12.2021.
//

import Foundation

struct CurrentWeatherData {
    let temp: Double
    let humidity: Int
    let wind: Double
    let sky: ESkyCondition
    let description: String
    let cityName: String
}

struct ForecastWeatherData {
    let daylist: [DailyForecastData]
}

struct DailyForecastData {
    let timestamp: TimeInterval
    let temp: Double
    let humidity: Int
    let wind: Double
    let sky: ESkyCondition
    let description: String
}

enum ESkyCondition: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
    case mist = "Mist"
    case drizzle = "Drizzle"
    case fog = "Fog"
}
