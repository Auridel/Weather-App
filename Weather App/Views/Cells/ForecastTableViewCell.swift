//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Олег Ефимов on 16.12.2021.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    public static let identifier = "ForecastTableViewCell"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(conditionImageView)
        contentView.addSubview(tempLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.text = nil
        conditionImageView.image = nil
        tempLabel.text = nil
    }
}
