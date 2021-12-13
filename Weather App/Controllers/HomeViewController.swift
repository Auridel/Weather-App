//
//  ViewController.swift
//  Weather App
//
//  Created by Олег Ефимов on 09.12.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let gradientLayer = GradientLayer()
    
    private var selectedLocationView: SelectedLocationView?
    
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
        selectedLocationView = SelectedLocationView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: 0,
                                                                  height: 0),
                                                        location: "Moscow")
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

}

