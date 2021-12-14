//
//  ViewController.swift
//  Weather App
//
//  Created by Олег Ефимов on 09.12.2021.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    private let gradientLayer = GradientLayer()
    
    private var selectedLocationView: SelectedLocationView?
    
    private let locationManager = CLLocationManager()
    
    private var forecastData: ForecastWeather?
    
    private let currentSkyCondition: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "sun")
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let currentWeatherView = CurrentWeatherView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        StorageManager.shared.getCityData()
        configureSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutSubviews()
    }
    
    private func configureSubviews() {
        let selectedLocation = StorageManager.shared.getStoredLocation()
        if let cityName = selectedLocation?.name {
            requestForecastFor(city: cityName)
        }
        
        selectedLocationView = SelectedLocationView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: 0,
                                                                  height: 0),
                                                    location: selectedLocation?.name ?? "Moscow")
        guard let selectedLocationView = selectedLocationView else {
            return
        }
        
        view.addSubview(scrollView)
        
        let gesture = UITapGestureRecognizer(target: self,
                                          action: #selector(didTapLocation))
        selectedLocationView.addGestureRecognizer(gesture)
        
        scrollView.addSubview(selectedLocationView)
        scrollView.addSubview(currentSkyCondition)
        scrollView.addSubview(currentWeatherView)
    }
    
    private func layoutSubviews() {
        scrollView.frame = view.bounds
        selectedLocationView?.frame = CGRect(x: 16,
                                             y: scrollView.safeAreaInsets.top + 16,
                                             width: scrollView.width,
                                             height: 24)
        currentSkyCondition.frame = CGRect(x: scrollView.width / 2 - 120,
                                           y: selectedLocationView?.bottom ?? 0 + 32,
                                           width: 240,
                                           height: 240)
        currentWeatherView.frame = CGRect(x: 16,
                                          y: currentSkyCondition.bottom + 32,
                                          width: scrollView.width - 32,
                                          height: 355)
    }
    
    // MARK: Actions
    @objc private func didTapLocation() {
        let popupVC = LocationPickerViewController()
        present(popupVC, animated: true)
    }
    
    // MARK: Common
    
    private func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func requestForecastFor(city name: String) {
        ApiManager.shared.getForecastByCityName(for: name) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                self.forecastData = forecast
                let todayWeather = forecast.list[0]
                let skyCondition = todayWeather.weather[0].main
                self.changeConditionTo(skyCondition)
                self.currentWeatherView.setWeatherConditions(temp: todayWeather.main.temp,
                                                             conditions: todayWeather.weather[0].weatherDescription.rawValue,
                                                             wind: todayWeather.wind.speed,
                                                             humidity: todayWeather.main.humidity)
            case .failure(_):
                break
            }
        }
    }
    
    public func changeConditionTo(_ condition: MainEnum) {
        // TODO: fix all cases
        var image: UIImage?
        switch condition {
        case .clear:
            image = UIImage(named: "sun")
        case .clouds:
            image = UIImage(named: "cloud_with_sun")
        case .rain:
            image = UIImage(named: "clouds")
        default:
            image = UIImage(named: "clouds")
        }
        DispatchQueue.main.async {
            self.currentSkyCondition.image = image
        }
    }

}


// MARK: CLLocatioDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationData: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        print("\(locationData.longitude) \(locationData.latitude)")
    }
}
