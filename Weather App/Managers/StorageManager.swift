//
//  File.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit
import CoreData

class StorageManager {
    
    public static let shared = StorageManager()
    
    private var isSync = false
    
    private var citiesData = [CityData]()
    
    private var cityModels = [CityEntity]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init(){}
    
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
    
    private func fetchDataFromFile() {
        if(citiesData.isEmpty) {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.citiesData = Utils.getCitiesJsonFromFile()
                guard let self = self else { return }
                
                for city in self.citiesData {
                    guard let entityDescription = NSEntityDescription.entity(forEntityName: "CityEntity", in: self.context),
                          let model = NSManagedObject(entity: entityDescription, insertInto: self.context) as? CityEntity
                    else { return }
                    
                    model.subcountry = city.subcountry
                    model.geonameid = Int64(city.geonameid)
                    model.country = city.country
                    model.name = city.name
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
    
    public func fetchCityDataFromDB(completion: @escaping ((Bool) -> Void)) {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        
        do {
            cityModels = try context.fetch(request)
            completion(true)
        } catch let error {
            print("DB fetch failed \(error)")
            completion(false)
        }
    }
    
    public func findCityBy(namePrefix name: String) -> [CityEntity] {
        if name.count < 3 {
            return []
        }
        return cityModels.filter { ($0.name ?? "").hasPrefix(name)}
    }
}
