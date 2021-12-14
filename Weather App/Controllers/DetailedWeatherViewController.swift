//
//  DetailedWeatherViewController.swift
//  Weather App
//
//  Created by Олег Ефимов on 14.12.2021.
//

import UIKit

class DetailedWeatherViewController: UIViewController {
    
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
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        backButton.addTarget(self,
                             action: #selector(didTapBackButton),
                             for: .touchUpInside)
        
        view.addSubview(backButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButton.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top,
                                  width: 100,
                                  height: 30)
    }
    
    
    // MARK: Actions
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
