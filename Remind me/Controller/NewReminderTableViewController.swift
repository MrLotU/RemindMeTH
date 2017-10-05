//
//  NewReminderTableViewController.swift
//  Remind me
//
//  Created by Jari Koopman on 03/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationDelegate {
    func setLocation(_ location: CLLocation, andName name: String)
}

class NewReminderTableViewController: UITableViewController {

    var location: CLLocation!
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New reminder"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
    }
    
    // MARK: Lazy vars
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "Reminder name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var arrivingLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "Arriving"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var arivingSwitch: UISwitch = {
        let aSwitch = UISwitch(frame: CGRect.zero)
        aSwitch.isOn = true
        aSwitch.addTarget(self, action: #selector(didUpdateArrivingSwitch), for: .valueChanged)
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return aSwitch
    }()
    
    lazy var locationNameTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "Location name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select a location"
        
        return label
    }()
    
    lazy var diameterLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Diameter"
        
        return label
    }()
    
    lazy var diameterValueLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "50 meters"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var diameterStepper: UIStepper = {
        let stepper = UIStepper(frame: CGRect.zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.value = 50
        stepper.stepValue = 5
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.addTarget(self, action: #selector(didUpdateDiameterStepper), for: .valueChanged)
        
        return stepper
    }()
}

// MARK: - Table view data source
extension NewReminderTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.contentView.addSubview(nameTextField)
            
            NSLayoutConstraint.activate([
                nameTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                nameTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                nameTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                nameTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        case (1, 0):
            cell.contentView.addSubviews([arrivingLabel, arivingSwitch])
            
            NSLayoutConstraint.activate([
                arrivingLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                arrivingLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                arrivingLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                arivingSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                arivingSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        case (2, 0):
            cell.contentView.addSubview(locationNameTextField)
            
            NSLayoutConstraint.activate([
                locationNameTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                locationNameTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                locationNameTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                locationNameTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        case (2, 1):
            cell.contentView.addSubview(locationLabel)
            cell.accessoryType = .disclosureIndicator
            
            NSLayoutConstraint.activate([
                locationLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                locationLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            ])
        case (3, 0):
            cell.contentView.addSubviews([diameterLabel, diameterValueLabel, diameterStepper])
            
            NSLayoutConstraint.activate([
                diameterLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                diameterLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                diameterLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                diameterLabel.trailingAnchor.constraint(equalTo: diameterValueLabel.leadingAnchor, constant: -20),
                
                diameterValueLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                diameterValueLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                diameterStepper.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                diameterStepper.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                ])
        default:
            break
        }

        return cell
    }
 
}

// MARK: - Table view delegate
extension NewReminderTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section, indexPath.row) == (2, 1) {
            addLocation()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Remind me to"
        case 1: return "When I'm"
        case 2:
            if arivingSwitch.isOn {
                return "At"
            } else {
                return "From"
            }
        case 3: return "Advanced settings"
        default: return ""
        }
    }
}

// MARK: - Helper methods
extension NewReminderTableViewController: LocationDelegate {
    @objc func doneButtonPressed() {
        guard let name = nameTextField.text, let locationName = locationNameTextField.text, locationNameTextField.text != "", nameTextField.text != "" else {
            let alertController = UIAlertController(title: "Missing required fields", message: "Please be sure that both Reminder Name and Location Name are not empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        guard self.location != nil else {
            let alertController = UIAlertController(title: "Missing required fields", message: "Please be sure that you set a Location for this reminder!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let location = Location.locationWith(name: locationName, andLat: self.location.coordinate.latitude, andLon: self.location.coordinate.longitude)
        Reminder.reminderWith(name: name, location: location, diameter: self.diameterStepper.value, isActive: true, ariving: self.arivingSwitch.isOn)
        
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonPressed() {
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    func addLocation() {
        let addLocationTVC = LocationTableViewController(delegate: self, location: nil)
        self.navigationController?.pushViewController(addLocationTVC, animated: true)
    }
    
    func setLocation(_ location: CLLocation, andName name: String) {
        self.location = location
        self.locationLabel.text = name
    }
    
    @objc func didUpdateArrivingSwitch(sender: UISwitch) {
        if sender.isOn {
            arrivingLabel.text = "Arriving"
        } else {
            arrivingLabel.text = "Departing"
        }
        tableView.reloadSections(IndexSet(integer: 2), with: .none)
    }
    
    @objc func didUpdateDiameterStepper(sender: UIStepper) {
        self.diameterValueLabel.text = "\(sender.value) meters"
    }
}
