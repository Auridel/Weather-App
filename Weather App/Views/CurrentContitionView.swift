//
//  CurrentContitionView.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit

enum ConditionType: String {
    case wind = "wind", humidity = "drop"
}

class CurrentContitionView: UIView {

    private let labelView = UIView()
    
    private let infoView = UIView()
    
    private let labelIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(labelView)
        self.addSubview(infoView)
        
        labelView.addSubview(labelIcon)
        labelView.addSubview(primaryLabel)
        infoView.addSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelView.layer.addBorder(edge: .right, color: .white, thickness: 1)
        labelView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.width / 2,
                                 height: self.height)
        infoView.frame = CGRect(x: labelView.right,
                                y: 0,
                                width: self.width / 2,
                                height: self.height)
        
        primaryLabel.frame = CGRect(x: labelView.right - 16 - 45,
                                    y: labelView.height / 2 - 9,
                                    width: 45,
                                    height: 18)
        labelIcon.frame = CGRect(x: primaryLabel.left - 16 - 24,
                                 y: labelView.height / 2 - 12,
                                 width: 24,
                                 height: 24)
        
        infoLabel.frame = CGRect(x:  16,
                                 y: infoView.height / 2 - 9,
                                 width: 80,
                                 height: 18)
    }
    
    public func configure(for type: ConditionType, value: Double) {
        switch type {
        case .wind:
            labelIcon.image = UIImage(systemName: "wind")
            primaryLabel.text = "Wind"
            infoLabel.text = "\(value) m/s"
        case .humidity:
            labelIcon.image = UIImage(systemName: "drop")
            primaryLabel.text = "Hum"
            infoLabel.text = "\(value) %"
        }
    }
}
