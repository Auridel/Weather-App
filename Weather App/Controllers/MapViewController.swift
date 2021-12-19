//
//  MapViewController.swift
//  Weather App
//
//  Created by Олег Ефимов on 19.12.2021.
//

import UIKit
import CoreLocation
import MapKit

protocol MapViewControllerDelegate: AnyObject {
    func didSelectLocation(coordinates: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {
    
    weak var delegate: MapViewControllerDelegate?
    
    public var defaultCoodrinates: CLLocationCoordinate2D?
    
    private var selectedCoordinates: CLLocationCoordinate2D?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back",
                        for: .normal)
        button.setTitleColor(.link,
                             for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18,
                                              weight: .semibold)
        return button
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select",
                        for: .normal)
        button.setTitleColor(.link,
                             for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.titleLabel?.textAlignment = .right
        return button
    }()
    
    private let map: MKMapView = {
        let map = MKMapView()
        map.isUserInteractionEnabled = true
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        map.frame = view.bounds
        selectButton.frame = CGRect(x: view.width - 75,
                                    y: 16,
                                    width: 75,
                                    height: 18)
        backButton.frame = CGRect(x: 0,
                                  y: 16,
                                  width: 75,
                                  height: 18)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let defaultCoodrinates = defaultCoodrinates {
            map.centerCoordinate = defaultCoodrinates
        }
    }
    
    
    // MARK: Actions
    
    @objc private func didFinishSelection() {
        guard let selectedCoordinates = selectedCoordinates else {
            return
        }
        delegate?.didSelectLocation(coordinates: selectedCoordinates)
        dismissVC()
    }
    
    @objc private func didTapBackButton() {
        dismissVC()
    }
    
    @objc private func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView,
                                      toCoordinateFrom: map)
        let pin = MKPointAnnotation()
        selectedCoordinates = coordinates
        map.removeAnnotations(map.annotations)
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }
    
    // MARK: Common
    
    private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureMap() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapMap(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        map.addGestureRecognizer(gesture)
    }
    
    private func configureView() {
        backButton.addTarget(self,
                             action: #selector(didTapBackButton),
                             for: .touchUpInside)
        selectButton.addTarget(self,
                               action: #selector(didFinishSelection),
                               for: .touchUpInside)
        
        configureMap()
        
        view.addSubview(map)
        view.addSubview(backButton)
        view.addSubview(selectButton)
    }

}
