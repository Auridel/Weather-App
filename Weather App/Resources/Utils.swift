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
    
    public static func formatDateToShortLabel(timestamp: TimeInterval) -> String {
        dateFormatter.dateFormat = "MMM, d"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
    
    public static func getImageByCondition(_ condition: ESkyCondition) -> UIImage? {
        switch condition {
        case .clear:
            return UIImage(named: "sun")
        case .clouds:
            return UIImage(named: "cloud_with_sun")
        case .rain:
            return UIImage(named: "clouds")
        default:
            return UIImage(named: "clouds")
        }
    }
}
