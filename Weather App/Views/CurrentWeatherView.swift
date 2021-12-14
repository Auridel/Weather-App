//
//  CurrentWeatherView.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit

class CurrentWeatherView: UIView {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 100)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        label.layer.shadowOffset = CGSize(width: 10, height: 10)
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 5
        return label
    }()
    
    private let skyConditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let windView = CurrentContitionView()
    
    private let humidityView = CurrentContitionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 191 / 255,
                                         green: 191 / 255,
                                         blue: 191 / 255,
                                         alpha: 1).cgColor
        self.backgroundColor = .white.withAlphaComponent(0.3)
        
        self.addSubview(dateLabel)
        self.addSubview(tempLabel)
        self.addSubview(skyConditionLabel)
        self.addSubview(windView)
        self.addSubview(humidityView)
        
        // FIXME: TEST DATA
        dateLabel.text = Utils.getCurrentDateAsHumanString()
        tempLabel.text = "-- °"
        skyConditionLabel.text = "--"
        windView.configure(for: .wind, value: 0)
        humidityView.configure(for: .humidity, value: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = CGRect(x: 16,
                                 y: 24,
                                 width: self.width - 32,
                                 height: 18)
        tempLabel.frame = CGRect(x: 16,
                                 y: dateLabel.bottom + 16,
                                 width: self.width - 32,
                                 height: 100)
        skyConditionLabel.frame = CGRect(x: 16,
                                         y: tempLabel.bottom + 16,
                                         width: self.width - 32,
                                         height: 24)
        windView.frame = CGRect(x: 16,
                                y: skyConditionLabel.bottom + 32,
                                width: self.width - 32,
                                height: 24)
        humidityView.frame = CGRect(x: 16,
                                y: windView.bottom + 16,
                                width: self.width - 32,
                                height: 24)
    }
    
    public func setWeatherConditions(temp: Double, conditions: String, wind: Double, humidity: Int) {
        dateLabel.text = Utils.getCurrentDateAsHumanString()
        tempLabel.text = "\(Int(temp)) °"
        skyConditionLabel.text = conditions
        windView.configure(for: .wind, value: wind)
        humidityView.configure(for: .humidity, value: Double(humidity))
    }
    
}
