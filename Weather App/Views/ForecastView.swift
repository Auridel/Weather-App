//
//  ForecastView.swift
//  Weather App
//
//  Created by Олег Ефимов on 16.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ForecastView: UIView {
    
    private var dateItems = PublishSubject<[String]>()
    
    private let bag = DisposeBag()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = true
        tableView.register(ForecastTableViewCell.self,
                           forCellReuseIdentifier: ForecastTableViewCell.identifier)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSubviewsFrame()
    }
    
    private func configureSubviews() {
        self.addSubview(tableView)
    }
    
    private func configureSubviewsFrame() {
        tableView.frame = self.bounds
    }
    
    private func bindTableView() {
        dateItems.bind(to: tableView.rx.items(cellIdentifier: ForecastTableViewCell.identifier,
                                                cellType: ForecastTableViewCell.self)) { row, model, cell in
            
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(String.self).bind { [weak self] model in
            guard let self = self,
                  let indexPath = self.tableView.indexPathForSelectedRow
            else {
                return
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }.disposed(by: bag)
    }
    
    public func pushForecastData(_ data: [String]) {
        dateItems.onNext(data)
    }
}
