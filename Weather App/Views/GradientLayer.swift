//
//  GradientLayer.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import Foundation
import UIKit

class GradientLayer: CAGradientLayer {
    private let colorTop = UIColor(red: 71 / 255,
                                   green: 191 / 255,
                                   blue: 223 / 255,
                                   alpha: 1).cgColor
    private let colorBottom = UIColor(red: 74 / 255,
                                      green: 145 / 255,
                                      blue: 255 / 255,
                                      alpha: 1).cgColor
    
    override init() {
        super.init()
        self.colors = [colorTop, colorBottom]
        self.locations = [0.0, 1.0]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
