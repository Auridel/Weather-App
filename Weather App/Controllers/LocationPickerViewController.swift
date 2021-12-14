//
//  LocationsViewController.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

protocol LocationPickerViewControllerDelegate: AnyObject {
    func didSelectLocation(model: CityEntity)
}

class LocationPickerViewController: UIViewController {
    
    private var items = PublishSubject<[CityEntity]>()
    
    private let bag = DisposeBag()
    
    private var searchResults = [CityEntity]()
    
    weak var delegate: LocationPickerViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LocationTableViewCell.self,
                           forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter your location"
        return searchBar
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "No results"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        bindTableData()
        bindSearchBar()
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(noResultsLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureSubviews()
    }
    
    private func configureSubviews() {
        searchBar.frame = CGRect(x: 8,
                                 y: 0,
                                 width: view.width - 16,
                                 height: 65)
        tableView.frame = CGRect(x: 0,
                                 y: searchBar.bottom,
                                 width: view.width,
                                 height: view.height - searchBar.height)
    }
    
    private func updateSearchResults(with results: [CityEntity]) {
        searchResults = results
        items.onNext(results)
    }
    
    private func bindTableData() {
        //bind items to table
        items.bind(to:
                    tableView.rx.items(cellIdentifier: LocationTableViewCell.identifier,
                                       cellType: LocationTableViewCell.self)) {row, model, cell in
            cell.configure(with: model)
        }.disposed(by: bag)
        //bind model to handler
        tableView.rx.modelSelected(CityEntity.self).bind {[weak self] model in
            guard let self = self, let indexPath = self.tableView.indexPathForSelectedRow
            else { return }
            self.didSelectLocation(model: model)
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
        //delegate
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    private func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] textValue in
                self?.handleSearch(with: textValue)
            }).disposed(by: bag)
    }
    
    private func handleSearch(with text: String) {
        let results = StorageManager.shared.findCityBy(namePrefix: text)
        print(results)
        updateSearchResults(with: results)
    }
    
    private func didSelectLocation(model: CityEntity) {
        delegate?.didSelectLocation(model: model)
    }
}

// MARK: TableViewDelegate

extension LocationPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
