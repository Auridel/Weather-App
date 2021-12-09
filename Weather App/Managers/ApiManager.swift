//
//  ApiManager.swift
//  Weather App
//
//  Created by Олег Ефимов on 09.12.2021.
//

import Foundation
import Alamofire

class ApiManager {
    
    typealias TypedCompletion<T> = (T) -> Void
    
    public static let shared = ApiManager()
    
    private let apiKey = Keys.apiKey
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    
    private init() {}
    
    public func getCurrentWeatherByCity(for city: String, completion: @escaping TypedCompletion<CurrentWeather>) {
        print(apiKey)
        AF.request("\(baseUrl)/weather",
                   parameters: ["q": city, "units": "metric", "appid": apiKey]
        ).validate()
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
                        let model = try jsonDecoder.decode(CurrentWeather.self, from: jsonData)
                        print(model)
                        completion(model)
                    } catch let error {
                        print("Cannot parse json")
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    public func getWeatherByCoordinates(latitude: String, longtitude: String, completion: @escaping TypedCompletion<CurrentWeather>) {
        AF.request("\(baseUrl)/weather", parameters: ["lat": latitude, "lon": longtitude, "units": "metric", "appid": apiKey])
            .validate().responseJSON { dataResponse in
                print(dataResponse)
                switch dataResponse.result {
                case .success:
                    guard let jsonData = dataResponse.data else {
                        print("Response doen't has any data")
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let model = try jsonDecoder.decode(CurrentWeather.self, from: jsonData)
                        print(model)
                        completion(model)
                    } catch let error {
                        print("Cannot parse json")
                        print(error)
                    }
                case .failure(let error):
                    print(error)
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
                        completion(model)
                    } catch let error {
                        print("Cannot parse json")
                        print(error)
                    }
                case .failure(let error):
                    print(error)
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
                        completion(model)
                    } catch let error {
                        print("Cannot parse json")
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
