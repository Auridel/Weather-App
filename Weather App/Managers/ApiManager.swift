//
//  ApiManager.swift
//  Weather App
//
//  Created by Олег Ефимов on 09.12.2021.
//

import Foundation
import Alamofire

class ApiManager {
    
    typealias TypedCompletion<T> = (Result<T, Error>) -> Void
    
    public static let shared = ApiManager()
    
    private let apiKey = Keys.apiKey
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    
    private init() {}
    
    enum ApiErrors: Error {
        case failedToGetDate
    }
    
    public func getCurrentWeatherByCity(for city: String, completion: @escaping TypedCompletion<CurrentWeatherData>) {
        print(apiKey)
        AF.request("\(baseUrl)/weather",
                   parameters: ["q": city, "units": "metric", "appid": apiKey]
        ).validate()
            .responseJSON { dataResponse in
                print(dataResponse)
                switch dataResponse.result {
                case .success:
                    guard let jsonData = dataResponse.data
                    else {
                        print("Response doen't has any data")
                        return
                    }
                    print(jsonData)
                    do {
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                        guard let parsedData = json as? [String: Any],
                              let mainData = parsedData["main"] as? [String: Any],
                              let temp = mainData["temp"] as? Double,
                              let humidity = mainData["humidity"] as? Int,
                              let windData = parsedData["wind"] as? [String: Any],
                              let windSpeed = windData["speed"] as? Double,
                              let weatherData = parsedData["weather"] as? [[String: Any]],
                              let stringCondition = weatherData[0]["main"] as? String,
                              let skyCondition = ESkyCondition(rawValue: stringCondition),
                              let description = weatherData[0]["description"] as? String
                        else {
                            print("Failed to parse json")
                            return
                        }
                        let weatherResult = CurrentWeatherData(temp: temp,
                                                               humidity: humidity,
                                                               wind: windSpeed,
                                                               sky: skyCondition,
                                                               description: description)
                        completion(.success(weatherResult))
                    } catch let error {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    public func getWeatherByCoordinates(latitude: String, longtitude: String, completion: @escaping TypedCompletion<CurrentWeatherData>) {
        AF.request("\(baseUrl)/weather", parameters: ["lat": latitude, "lon": longtitude, "units": "metric", "appid": apiKey])
            .validate().responseJSON { dataResponse in
                print(dataResponse)
                switch dataResponse.result {
                case .success:
                    guard let jsonData = dataResponse.data
                    else {
                        print("Response doen't has any data")
                        return
                    }
                    print(jsonData)
                    do {
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                        guard let parsedData = json as? [String: Any],
                              let mainData = parsedData["main"] as? [String: Any],
                              let temp = mainData["temp"] as? Double,
                              let humidity = mainData["humidity"] as? Int,
                              let windData = parsedData["wind"] as? [String: Any],
                              let windSpeed = windData["speed"] as? Double,
                              let weatherData = parsedData["weather"] as? [[String: Any]],
                              let stringCondition = weatherData[0]["main"] as? String,
                              let skyCondition = ESkyCondition(rawValue: stringCondition),
                              let description = weatherData[0]["description"] as? String
                        else {
                            print("Failed to parse json")
                            return
                        }
                        let weatherResult = CurrentWeatherData(temp: temp,
                                                               humidity: humidity,
                                                               wind: windSpeed,
                                                               sky: skyCondition,
                                                               description: description)
                        completion(.success(weatherResult))
                    } catch let error {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    public func getForecastByCityName(for city: String, completion: @escaping TypedCompletion<ForecastWeather>) {
        AF.request("\(baseUrl)/forecast", parameters: ["q": city, "units": "metric", "appid": apiKey])
            .validate()
            .responseJSON { dataResponse in
                print(dataResponse)
                switch dataResponse.result {
                case .success:
                    guard let jsonData = dataResponse.data else {
                        print("Response doen't has any data")
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let model = try jsonDecoder.decode(ForecastWeather.self, from: jsonData)
                        print(model)
                        completion(.success(model))
                    } catch let error {
                        print("Cannot parse json")
                        print(error)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    public func getForecastByCoordinates(latitude: String, longtitude: String, completion: @escaping TypedCompletion<ForecastWeather>) {
        AF.request("\(baseUrl)/forecast", parameters: ["lat": latitude, "lon": longtitude, "units": "metric", "appid": apiKey])
            .validate()
            .responseJSON { dataResponse in
                print(dataResponse)
                switch dataResponse.result {
                case .success:
                    guard let jsonData = dataResponse.data else {
                        print("Response doen't has any data")
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let model = try jsonDecoder.decode(ForecastWeather.self, from: jsonData)
                        print(model)
                        completion(.success(model))
                    } catch let error {
                        print("Cannot parse json")
                        print(error)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
}
