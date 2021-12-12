//
//  LocationTableViewCell.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    public static let identifier = "LocationTableViewCell"
    
    private let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label.withAlphaComponent(0.57)
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
 
        contentView.addSubview(cellImage)
        contentView.addSubview(locationLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellImage.frame = CGRect(x: 16,
                                 y: contentView.height / 2 - 12,
                                 width: 24,
                                 height: 24)
        locationLabel.frame = CGRect(x: cellImage.right + 16,
                                     y: contentView.height / 2 - 9,
                                     width: contentView.width - 16 * 3 - cellImage.width,
                                     height: 18)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        locationLabel.text = ""
    }
    
    public func configure(with name: String) {
        locationLabel.text = name
    }
}
