//
//  HourlyCollectionViewCell.swift
//  Weather App
//
//  Created by Олег Ефимов on 15.12.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "HourlyCollectionViewCell"
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "-- °"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "--:--"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clear
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSubviewsFrames()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tempLabel.text = nil
        timeLabel.text = nil
        conditionImage.image = nil
    }
    
    private func configureSubviews() {
        contentView.addSubview(tempLabel)
        contentView.addSubview(conditionImage)
        contentView.addSubview(timeLabel)
    }
    
    private func configureSubviewsFrames() {
        tempLabel.frame = CGRect(x: 0,
                                 y: 5,
                                 width: contentView.width,
                                 height: 28)
        conditionImage.frame = CGRect(x: (contentView.width - 44) / 2,
                                      y: tempLabel.bottom + 20,
                                      width: 44,
                                      height: 44)
        timeLabel.frame = CGRect(x: 0,
                                 y: conditionImage.bottom + 20,
                                 width: contentView.width,
                                 height: 28)
    }
    
    public func configure(with model: DailyForecastData) {
        tempLabel.text = "\(Int(model.temp)) °"
        conditionImage.image = Utils.getImageByCondition(model.sky)
        timeLabel.text = Utils.formatDateToShortLabel(timestamp: model.timestamp, for: .time)
    }
}
