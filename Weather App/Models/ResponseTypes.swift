//
//  ResponseTypes.swift
//  Weather App
//
//  Created by Олег Ефимов on 09.12.2021.
//

import Foundation

// MARK: Enums

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}


// MARK: Api Calls

///Current Weather Responsse
struct CurrentWeather: Codable {
    let coord: [String: Float]
    let weather: [WeatherForCurrent]
    let base: String
    let main: MainWeatherParams
    let visibility:Float
    let wind: Wind
    let clouds: CloudParams
    let dt: Double
    let sys: LocalSunrise
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

/// 5-day Weather Forecast Response
struct ForecastWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [DayList]
    let city: City
}

// MARK: Minor Models

// MARK: City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: DayList
struct DayList: Codable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: MainEnum
    let weatherDescription: Description
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: WeatherForCurrent
struct WeatherForCurrent: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

//MARK: MainWeatherParams
struct MainWeatherParams: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Float
    let humidity: Float
}

// MARK: Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

// MARK: Wind
struct CloudParams: Codable {
    let all: Float
}

// MARK: LocalSunrise
struct LocalSunrise: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}


