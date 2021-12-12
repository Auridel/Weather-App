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
        
        selectedLocationView = SelectedLocationView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: 0,
                                                                  height: 0),
                                                        location: "Moscow")
        guard let selectedLocationView = selectedLocationView else {
            return
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(selectedLocationView)
        
        scrollView.addSubview(currentWeatherView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        selectedLocationView?.frame = CGRect(x: 16,
                                             y: scrollView.safeAreaInsets.top + 16,
                                             width: scrollView.width,
                                             height: 24)
        currentWeatherView.frame = CGRect(x: 16,
                                          y: selectedLocationView?.bottom ?? 0 + 32,
                                          width: scrollView.width - 32,
                                          height: 355)
    }

}

