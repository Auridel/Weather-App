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
        view.addSubview(selectedLocationView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectedLocationView?.frame = CGRect(x: 16,
                                             y: view.safeAreaInsets.top + 16,
                                             width: view.width,
                                             height: 24)
    }

}

