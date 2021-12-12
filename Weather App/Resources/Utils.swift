//
//  Utils.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit

class Utils {
    private static let dateFormatter = DateFormatter()
    
    public static func getCurrentDateAsHumanString() -> String {
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: Date())
    }
    
    public static func getCitiesJsonFromFile() -> [CityData] {
        var result = [CityData]()
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let entries = json as? NSArray, let cities = entries as? [[String: Any]] {
                    for city in cities {
                        guard let country = city["country"] as? String,
                              let geonameid = city["geonameid"] as? Int,
                              let name = city["name"] as? String,
                              let subcountry = city["subcountry"] as? String
                        else { continue }
                        result.append(CityData(country: country,
                                               geonameid: geonameid,
                                               name: name,
                                               subcountry: subcountry))
                    }
                }
            } catch let error {
                print(error)
            }
        }
        return result
    }
}
