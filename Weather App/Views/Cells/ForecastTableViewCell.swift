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
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(conditionImageView)
        contentView.addSubview(tempLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = CGRect(x: 0,
                                 y: contentView.height / 2 - 9,
                                 width: 70,
                                 height: 18)
        conditionImageView.frame = CGRect(x: contentView.width / 2 - 28,
                                          y: contentView.height / 2 - 28,
                                          width: 56,
                                          height: 56)
        tempLabel.frame = CGRect(x: contentView.width - 70,
                                 y: contentView.height / 2 - 9,
                                 width: 70,
                                 height: 18)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.text = nil
        conditionImageView.image = nil
        tempLabel.text = nil
    }
    
    public func configure(with model: DailyForecastData) {
        dateLabel.text = Utils.formatDateToShortLabel(timestamp: model.timestamp)
        conditionImageView.image = Utils.getImageByCondition(model.sky)
        tempLabel.text = "\(Int(model.temp))°C"
    }
}
