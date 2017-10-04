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
    
    init(delegate: LocationDelegate) {
        self.delegate = delegate
        
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
//        map.centerCoordinate
        
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select location"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        switch (indexPath.section, indexPath.row) {
        case (0, 0): break
        case (1, 0): break
        default: break
        }
        
        return cell
    }
}

// MARK: - Helper methods

extension AddLocationTableViewController {
    @objc func doneButtonPressed() {
        
    }
    
    @objc func cancelButtonPressed() {
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
}











