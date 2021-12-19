//
//  Utils.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit

class Utils {
    
    public enum DateLabel {
        case date, time
    }
    
    private static let dateFormatter = DateFormatter()
    
    public static func getCurrentDateAsHumanString() -> String {
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: Date())
    }
    
    public static func formatDateToShortLabel(timestamp: TimeInterval, for labelType: DateLabel) -> String {
        switch labelType {
        case .date:
            dateFormatter.dateFormat = "MMM, d"
        case .time:
            dateFormatter.dateFormat = "HH:mm"
        }
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
    
    public static func getImageByCondition(_ condition: ESkyCondition) -> UIImage? {
        switch condition {
        case .clear:
            return UIImage(named: "sun")
        case .clouds:
            return UIImage(named: "clouds")
        case .rain:
            return UIImage(named: "rain")
        case .snow:
            return UIImage(named: "snow")
        case .mist:
            return UIImage(named: "fog")
        case .drizzle:
            return UIImage(named: "rain")
        case .fog:
            return UIImage(named: "fog")
        }
    }
}
