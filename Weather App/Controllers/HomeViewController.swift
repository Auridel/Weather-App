//
//  ViewController.swift
//  Weather App
//
//  Created by Олег Ефимов on 09.12.2021.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    private var selectedCity: String?
    
    private var userLocation: CLLocationCoordinate2D?
    
    private let gradientLayer = GradientLayer()
    
    private var selectedLocationView: SelectedLocationView?
    
    private let locationManager = CLLocationManager()
    
    private var forecastData: CurrentWeatherData?
    
    private let mapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "map"),
                        for: .normal)
        button.imageView?.tintColor = .white
        button.setTitle("Open Map",
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        return button
    }()
    
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
        configureLocationManager()
        
        configureSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutSubviews()
    }
    
    private func configureSubviews() {
        let selectedLocation = StorageManager.shared.getStoredLocation()
        if let cityName = selectedLocation?.name {
            selectedCity = cityName
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
        
        let tapCurentWeatherWidgetGesture = UITapGestureRecognizer(target: self,
                                                                   action: #selector(didTapCurrentWeatherWidget))
        currentWeatherView.addGestureRecognizer(tapCurentWeatherWidgetGesture)
        
        mapButton.addTarget(self,
                            action: #selector(didTapMapButton),
                            for: .touchUpInside)
        
        scrollView.addSubview(selectedLocationView)
        scrollView.addSubview(currentSkyCondition)
        scrollView.addSubview(currentWeatherView)
        scrollView.addSubview(mapButton)
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
        mapButton.frame = CGRect(x: scrollView.width / 2 - 75,
                                 y: currentWeatherView.bottom + 36,
                                 width: 150,
                                 height: 18)
    }
    
    // MARK: Actions
    @objc private func didTapLocation() {
        let locationVC = LocationPickerViewController()
        locationVC.delegate = self
        present(locationVC, animated: true)
    }
    
    @objc private func didTapCurrentWeatherWidget() {
        guard let selectedCity = selectedCity else {
            return
        }
        let detailedWeatherVC = DetailedWeatherViewController()
        detailedWeatherVC.modalPresentationStyle = .fullScreen
        detailedWeatherVC.selectedCity = selectedCity
        present(detailedWeatherVC, animated: true)
    }
    
    @objc private func didTapMapButton() {
        let mapVC = MapViewController()
        mapVC.defaultCoodrinates = userLocation
        mapVC.delegate = self
        present(mapVC, animated: true)
    }
    
    // MARK: Common
    
    private func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    private func requestForecastFor(city name: String) {
        ApiManager.shared.getCurrentWeatherByCity(for: name) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                self.applyForecastData(forecast: forecast)
            case .failure(_):
                print("Failed to update weather")
                break
            }
        }
    }
    
    private func changeConditionTo(_ condition: ESkyCondition) {
        // TODO: fix all cases
        let image = Utils.getImageByCondition(condition)
        DispatchQueue.main.async {
            self.currentSkyCondition.image = image
        }
    }
    
    private func applyForecastData(forecast: CurrentWeatherData) {
        self.forecastData = forecast
        self.changeConditionTo(forecast.sky)
        self.currentWeatherView.setWeatherConditions(temp: forecast.temp,
                                                     conditions: forecast.description,
                                                     wind: forecast.wind,
                                                     humidity: forecast.humidity)
    }

}


// MARK: CLLocatioDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationData = locations.first?.coordinate else {
            return
        }
        userLocation = locationData
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location \(error)")
    }
}

// MARK: LocationPicker Delegate

extension HomeViewController: LocationPickerViewControllerDelegate {
    
    func didSelectLocation(model: CityEntity) {
        guard let name = model.name else{ return }
        selectedCity = model.name
        selectedLocationView?.configure(with: name)
        requestForecastFor(city: name)
        StorageManager.shared.setUserSelectedCity(with: Int(model.geonameid))
    }
    
}

// MARK: Map Delegate

extension HomeViewController: MapViewControllerDelegate {
    
    func didSelectLocation(coordinates: CLLocationCoordinate2D) {
        ApiManager.shared.getWeatherByCoordinates(latitude: coordinates.latitude,
                                                  longtitude: coordinates.longitude) { [weak self] resultData in
            guard let self = self else { return }
            switch resultData{case .success(let forecast):
                self.applyForecastData(forecast: forecast)
                self.selectedLocationView?.configure(with: forecast.cityName)
                self.selectedCity = forecast.cityName
            case .failure(_):
                print("Failed to get forecast")
            }
        }
    }
    
}
