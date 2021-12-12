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
}
