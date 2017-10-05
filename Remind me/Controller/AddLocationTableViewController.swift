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
    
    init(delegate: LocationDelegate) {
        self.delegate = delegate
        self.locationManager = LocationManager()
        
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lazy vars
    
    lazy var currentLocationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "Use current location"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var map: MKMapView = {
        let map = MKMapView(frame: CGRect.zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        
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
    }
}

// MARK: - Table view delegate

extension AddLocationTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 15
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section, indexPath.row) == (0, 0) {
            return 44
        } else {
            return tableView.frame.height - 59 - 44
        }
    }
}

// MARK: - Table view data source
extension AddLocationTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Or select a location on the map"
        } else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.contentView.addSubview(currentLocationLabel)
            
            NSLayoutConstraint.activate([
                currentLocationLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                currentLocationLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                currentLocationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                currentLocationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
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

// MARK: - MKMapView Delegate

extension AddLocationTableViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("wew")
    }
}

// MARK: - Helper methods

extension AddLocationTableViewController {
    @objc func doneButtonPressed() {
        
    }
    
    @objc func didLongPressMap(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.map)
            let coords = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            let location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let error = error {
                    print("Unresolved error! \(error), \(error.localizedDescription)")
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("uh oh")
                    return
                }
                
                if let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea, placemark.name != "", placemark.name != "", placemark.administrativeArea != "" {
                    annotation.title = "\(name)"
                    annotation.subtitle = "\(city), \(area)"
                    self.map.removeAnnotations(self.map.annotations)
                    self.map.addAnnotation(annotation)
                } else {
                    annotation.title = "Unknown location"
                    annotation.subtitle = "\(coords)"
                    self.map.removeAnnotations(self.map.annotations)
                    self.map.addAnnotation(annotation)
                }
            })
        }
    }
    
    @objc func cancelButtonPressed() {
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
}












