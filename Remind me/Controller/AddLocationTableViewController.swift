//
//  AddLocationTableViewController.swift
//  Remind me
//
//  Created by Jari Koopman on 03/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationTableViewController: UITableViewController {
    
    let delegate: LocationDelegate
    let locationManager: LocationManager
    
    var location: CLLocation = CLLocation()
    var locationName: String = "" {
        didSet {
            self.selectedLocationLabel.text = locationName
        }
    }
    
    init(delegate: LocationDelegate) {
        self.delegate = delegate
        self.locationManager = LocationManager()
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lazy vars
    
    lazy var selectedLocationActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    lazy var selectedLocationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = self.locationName
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var currentLocationActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    lazy var useCurrentLocationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "Use current location"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var map: MKMapView = {
        let map = MKMapView(frame: CGRect.zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressMap))
        gestureRecognizer.minimumPressDuration = 2.0
        map.addGestureRecognizer(gestureRecognizer)
        
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select location"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        getCurrentLocation()
    }
}

// MARK: - Table view delegate

extension AddLocationTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section, indexPath.row) == (1, 0) {
            getCurrentLocation()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 25
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section, indexPath.row) == (1, 1) {
            return tableView.frame.height - 59 - 44
        } else {
            return 44
        }
    }
}

// MARK: - Table view data source
extension AddLocationTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Use current location or long press on map to select a custom location"
        } else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.contentView.addSubviews([selectedLocationLabel, selectedLocationActivityIndicator])
            
            NSLayoutConstraint.activate([
                selectedLocationLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                selectedLocationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                selectedLocationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                selectedLocationActivityIndicator.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                selectedLocationActivityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                selectedLocationActivityIndicator.heightAnchor.constraint(equalToConstant: 29),
                selectedLocationActivityIndicator.widthAnchor.constraint(equalTo: selectedLocationActivityIndicator.heightAnchor)
                ])
        case (1, 0):
            cell.contentView.addSubviews([useCurrentLocationLabel, currentLocationActivityIndicator])
            
            NSLayoutConstraint.activate([
                useCurrentLocationLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                useCurrentLocationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                useCurrentLocationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                currentLocationActivityIndicator.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                currentLocationActivityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                currentLocationActivityIndicator.heightAnchor.constraint(equalToConstant: 29),
                currentLocationActivityIndicator.widthAnchor.constraint(equalTo: currentLocationActivityIndicator.heightAnchor)

            ])
        case (1, 1):
            cell.contentView.addSubview(map)
            
            NSLayoutConstraint.activate([
                map.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                map.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                map.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                map.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        default: break
        }
        
        return cell
    }
}

// MARK: - Helper methods

extension AddLocationTableViewController {
    @objc func doneButtonPressed() {
        guard self.location != CLLocation(), self.locationName != "" else {
            let alertController = UIAlertController(title: "Missing location!", message: "Please be sure that you selected a location!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        delegate.setLocation(self.location, andName: self.locationName)
        
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didLongPressMap(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.locationName = ""
            selectedLocationActivityIndicator.isHidden = false
            selectedLocationActivityIndicator.startAnimating()

            locationManager.onLocationFix = nil
            let touchPoint = sender.location(in: self.map)
            let coords = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            let location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
            self.location = location
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: updateLocations)
        }
    }
    
    func activityDone() {
        currentLocationActivityIndicator.stopAnimating()
        selectedLocationActivityIndicator.stopAnimating()
        currentLocationActivityIndicator.isHidden = true
        selectedLocationActivityIndicator.isHidden = true
    }
    
    func getCurrentLocation() {
        self.locationName = ""
        selectedLocationActivityIndicator.isHidden = false
        currentLocationActivityIndicator.isHidden = false
        currentLocationActivityIndicator.startAnimating()
        selectedLocationActivityIndicator.startAnimating()
        
        locationManager.onLocationFix = updateLocations
        locationManager.manager.requestLocation()
    }
    
    func updateLocations(placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unresolved error! \(error), \(error.localizedDescription)")
            return
        }
        
        guard let placemark = placemarks?.first, let location = placemark.location else {
            print("uh oh!")
            return
        }
        
        let coords = location.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        
        self.map.setCenter(coords, animated: true)
        self.map.removeAnnotations(self.map.annotations)
        self.map.setRegion(MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: true)
        
        if let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea, placemark.name != "", placemark.name != "", placemark.administrativeArea != "" {
            annotation.title = "\(name)"
            annotation.subtitle = "\(city), \(area)"
            self.locationName = "\(name), \(city), \(area)"
        } else {
            annotation.title = "Unknown location"
            annotation.subtitle = "\(coords)"
            self.locationName = "Unknown location \(coords)"
        }
        self.map.addAnnotation(annotation)
        self.activityDone()
    }
    
    @objc func cancelButtonPressed() {
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
}












