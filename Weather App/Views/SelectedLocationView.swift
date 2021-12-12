//
//  SelectedLocationView.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit

protocol SelectedLocationViewDelegate: AnyObject {
    func didChangeLocation()
}

class SelectedLocationView: UIView {
    
    private var selectedLocation: String?
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "mappin.and.ellipse")
        imageView.image = image
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        return label
    }()

    init(frame: CGRect, location: String) {
        super.init(frame: frame)
        
        selectedLocation = location
        locationLabel.text = location
        
        self.addSubview(locationImageView)
        self.addSubview(locationLabel)
        self.addSubview(arrowImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        locationImageView.frame = CGRect(x: 0,
                                         y: self.height / 2 - 12,
                                         width: 24,
                                         height: 24)
        if let text = locationLabel.text {
            var rect: CGRect = locationLabel.frame
            rect.size = (text.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: locationLabel.font.fontName, size: locationLabel.font.pointSize) ?? 0])) as CGSize
            let maxLabelWidth: CGFloat = self.width - locationImageView.width - 12 - 16 * 4;
            locationLabel.frame = CGRect(x: locationImageView.right + 16,
                                         y: self.height / 2 - 12,
                                         width: rect.width + 10 > maxLabelWidth ? maxLabelWidth : rect.width + 10,
                                         height: 24)
            arrowImageView.frame = CGRect(x: locationLabel.right + 16,
                                          y: self.height / 2 - 6,
                                          width: 12,
                                          height: 12)
        }
        
    }
}
