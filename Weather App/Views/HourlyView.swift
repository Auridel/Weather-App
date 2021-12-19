//
//  HourlyView.swift
//  Weather App
//
//  Created by Олег Ефимов on 15.12.2021.
//

import UIKit
import RxCocoa
import RxSwift

class HourlyView: UIView {
    
    private var hourlyData = PublishSubject<[DailyForecastData]>()
    
    private let bag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0)
        layout.itemSize = CGSize(width: 70,
                                 height: 155)
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourlyCollectionViewCell.self,
                                forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        bindCollectionView()
        self.addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = self.bounds
    }
    
    // TODO: types
    private func bindCollectionView() {
        hourlyData.asObservable().bind(to:
                            collectionView.rx.items(cellIdentifier: HourlyCollectionViewCell.identifier,
                                                    cellType: HourlyCollectionViewCell.self)) { _, model, cell in
            cell.configure(with: model)
        }.disposed(by: bag)
    }
    
    public func pushHourlyData(_ data: [DailyForecastData]) {
        hourlyData.onNext(data)
    }
}
