//
//  LocationsViewController.swift
//  Weather App
//
//  Created by Олег Ефимов on 12.12.2021.
//

import UIKit

protocol LocationPickerViewControllerDelegate: AnyObject {
    func didSelectLocation(name: String)
}

class LocationPickerViewController: UIViewController {
    
    private var searchResults = [CityData]()
    
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
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(noResultsLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.frame = CGRect(x: 8,
                                 y: 0,
                                 width: view.width - 16,
                                 height: 65)
        tableView.frame = CGRect(x: 0,
                                 y: searchBar.bottom,
                                 width: view.width,
                                 height: view.height - searchBar.height)
    }
    
    private func updateSearchResults(with results: [CityData]) {
        searchResults = results
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}


// MARK: UISearchBarDelegate

extension LocationPickerViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Debounce next
        let results = StorageManager.shared.findCityBy(namePrefix: searchText)
        print(results)
        updateSearchResults(with: results)
    }
}

// MARK: TableView

extension LocationPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier,
                                                 for: indexPath) as! LocationTableViewCell
        cell.configure(with: searchResults[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

