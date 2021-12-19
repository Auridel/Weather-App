//
//  DetailedWeatherViewController.swift
//  Weather App
//
//  Created by Олег Ефимов on 14.12.2021.
//

import UIKit

class DetailedWeatherViewController: UIViewController {
    
    public var selectedCity: String?
    
    private var forecast: Any?
    
    private let gradientLayer = GradientLayer()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"),
                        for: .normal)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.text = Utils.formatDateToShortLabel(timestamp: Date().timeIntervalSince1970,
                                                  for: .date)
        label.textAlignment = .right
        return label
    }()
    
    private let nextForecastLabel: UILabel = {
        let label = UILabel()
        label.text = "Next Forecast"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let hourlyView = HourlyView()
    
    private let forecastView = ForecastView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        configureSubviews()
        fetchForecastData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutSubviews()
    }
    
    private func configureSubviews() {
        backButton.addTarget(self,
                             action: #selector(didTapBackButton),
                             for: .touchUpInside)
        
        view.addSubview(backButton)
        view.addSubview(todayLabel)
        view.addSubview(dateLabel)
        view.addSubview(hourlyView)
        view.addSubview(nextForecastLabel)
        view.addSubview(forecastView)
    }
    
    private func layoutSubviews() {
        backButton.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top,
                                  width: 100,
                                  height: 30)
        todayLabel.frame = CGRect(x: 16,
                                  y: backButton.bottom + 30,
                                  width: 70,
                                  height: 22)
        dateLabel.frame = CGRect(x: view.right - 16 - 70,
                                 y: backButton.bottom + 30,
                                 width: 70,
                                 height: 18)
        hourlyView.frame = CGRect(x: 0,
                                  y: todayLabel.bottom + 30,
                                  width: view.width,
                                  height: 160)
        nextForecastLabel.frame = CGRect(x: 16,
                                         y: hourlyView.bottom + 24,
                                         width: view.width - 32,
                                         height: 22)
        forecastView.frame = CGRect(x: 16,
                                    y: nextForecastLabel.bottom + 16,
                                    width: view.width - 32,
                                    height: view.height - nextForecastLabel.bottom - 16 - view.safeAreaInsets.bottom)
    }
    
    
    // MARK: Actions
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Common
    
    private func fetchForecastData() {
        guard let selectedCity = selectedCity else {
            return
        }
        ApiManager.shared.getDailyForecastByCityName(for: selectedCity,
                                                   completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                self.updateForeastViews(with: forecast.daylist)
            case .failure(_):
                break
            }
            
        })
    }
    
    private func updateForeastViews(with models: [DailyForecastData]) {
        var dailyData = [DailyForecastData]()
        var lastTimestamp: TimeInterval = 0
        for model in models {
            if (lastTimestamp == 0 || (lastTimestamp + (24 * 60 * 60)) <= model.timestamp) {
                dailyData.append(model)
                lastTimestamp = model.timestamp
            }
        }
        let hourlyData = Array(models[..<7])
        hourlyView.pushHourlyData(hourlyData)
        forecastView.pushForecastData(dailyData)
    }
}
