//
//  File.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit
import CoreData

/// CoreData Manager
class StorageManager {
    
    public static let shared = StorageManager()
    
    private var isSync = false
    
    private var cityModels = [CityEntity]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init(){}
    
    // MARK: Public
    
    /// Load entities from DB
    public func getCityData() {
        if !isSync, cityModels.isEmpty {
            fetchCityDataFromDB { [weak self] isSuccess in
                guard let self = self else { return }
                if (isSuccess && self.cityModels.isEmpty) || !isSuccess  {
                    self.fetchDataFromFile()
                }
                self.isSync = true
            }
        }
    }
    
    /// Find city data in DB by prefix
    public func findCityBy(namePrefix name: String) -> [CityEntity] {
        if name.count < 3 {
            return []
        }
        return cityModels.filter { ($0.name?.lowercased() ?? "").hasPrefix(name.lowercased())}
    }
    
    public func setUserSelectedCity(with geonameId: Int) {
        UserDefaults.standard.setValue(geonameId, forKey: StorageKeys.selectedCity.rawValue)
    }
    
    public func getStoredLocation() -> CityEntity? {
        let defaultId = 524901
        let storedId = UserDefaults.standard.integer(forKey: StorageKeys.selectedCity.rawValue)
        if storedId != 0, let model = cityModels.first(where: { $0.geonameid == storedId }) {
            return model
        } else if let model = cityModels.first(where: {$0.geonameid == defaultId }) {
            return model
        }
        return nil
    }
    
    // MARK: Private
    
    /// Fetches data from json file
    private func fetchDataFromFile() {
        if(cityModels.isEmpty) {
            DispatchQueue.global(qos: .background).async { [weak self] in
                let citiesData = self?.getCitiesJsonFromFile()
                guard let self = self,
                      let cities = citiesData
                else { return }
                
                for city in cities {
                    guard let country = city["country"] as? String,
                          let geonameid = city["geonameid"] as? Int,
                          let name = city["name"] as? String,
                          let subcountry = city["subcountry"] as? String
                    else { continue }
                    guard let entityDescription = NSEntityDescription.entity(forEntityName: "CityEntity", in: self.context),
                          let model = NSManagedObject(entity: entityDescription, insertInto: self.context) as? CityEntity
                    else { return }
                    
                    model.subcountry = subcountry
                    model.geonameid = Int64(geonameid)
                    model.country = country
                    model.name = name
                }
                
                if self.context.hasChanges {
                    do {
                        try self.context.save()
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }
    
    /// Fetches entries fron DB to array
    private func fetchCityDataFromDB(completion: @escaping ((Bool) -> Void)) {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        
        do {
            cityModels = try context.fetch(request)
            completion(true)
        } catch let error {
            print("DB fetch failed \(error)")
            completion(false)
        }
    }
    
    private func getCitiesJsonFromFile() -> [[String: Any]]? {
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let entries = json as? NSArray, let cities = entries as? [[String: Any]] {
                    return cities
                }
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}
