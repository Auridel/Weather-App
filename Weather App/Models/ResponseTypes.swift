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
    case snow = "Snow"
    case mist = "Mist"
    case drizzle = "Drizzle"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case lightSnow = "light snow"
    case snow = "snow"
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}


// MARK: Api Calls


// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let coord: CurCoord
    let weather: [Weather]
    let base: String
    let main: CurMain
    let visibility: Int
    let wind: CurWind
    let clouds: CurClouds
    let dt: Int
    let sys: CurSys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: ForecastWeather
///5-day Weather Forecast Response
struct ForecastWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [DayList]
    let city: City
}

// MARK: - Clouds
struct CurClouds: Codable {
    let all: Int
}

// MARK: - Coord
struct CurCoord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct CurMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct CurSys: Codable {
    let type, id: Int?
    let country: String
    let sunrise, sunset: Int
}


// MARK: - Wind
struct CurWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
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


