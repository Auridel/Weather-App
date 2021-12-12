//
//  File.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import Foundation

class StorageManager {
    
    public static let shared = StorageManager()
    
    private var citiesData = [CityData]()
    
    private init(){}
    
    public func getCityData() {
        if(citiesData.isEmpty) {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.citiesData = Utils.getCitiesJsonFromFile()
            }
        }
    }
    
    public func findCityBy(namePrefix name: String) -> [CityData] {
        if name.count < 3 {
            return []
        }
        return citiesData.filter { $0.name.hasPrefix(name)}
    }
}
