//
//  EditTableViewController.swift
//  Remind me
//
//  Created by Jari Koopman on 03/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import CoreLocation

class EditTableViewController: UITableViewController {
    
    fileprivate let reminder: Reminder
    var location: CLLocation
    
    init(reminder: Reminder) {
        self.reminder = reminder
        self.location = reminder.location
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Editing \(self.reminder.name)"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveReminder))
        
        CLGeocoder().reverseGeocodeLocation(self.reminder.location) { (placemarks, error) in
            if let error = error {
                print("Error: \(error), \(error.localizedDescription)")
                return
            }
            
            guard let placemarks = placemarks, let placemark = placemarks.first else {
                print("Couldn't get placemark from placemarks")
                return
            }
            
            guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else {
                self.locationLabel.text = "\(self.reminder.lat), \(self.reminder.long)"
                return
            }
            
            self.locationLabel.text = "\(name), \(city), \(area)"
        }
    }
    
    // MARK: Edit fields
    lazy var stateLabel: UILabel = {
        
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        if self.reminder.isActive {
            label.text = "Active"
        } else {
            label.text = "Disabled"
        }
        return label
    }()
    
    lazy var stateSwitch: UISwitch = {
        let sSwitch = UISwitch(frame: CGRect.zero)
        sSwitch.translatesAutoresizingMaskIntoConstraints = false
        sSwitch.isOn = self.reminder.isActive
        sSwitch.addTarget(self, action: #selector(didUpdateStateSwitch), for: .valueChanged)
        
        return sSwitch
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.text = self.reminder.name
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var arrivingStateLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        if self.reminder.ariving {
            label.text = "Arriving"
        } else {
            label.text = "Departing"
        }
        
        return label
    }()
    
    lazy var arrivingStateSwitch: UISwitch = {
        let aSwitch = UISwitch(frame: CGRect.zero)
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.isOn = self.reminder.ariving
        aSwitch.addTarget(self, action: #selector(didUpdateArrivingSwitch), for: .valueChanged)
        
        return aSwitch
    }()
    
    lazy var locationNameTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.text = self.reminder.locName
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        label.text = "\(self.reminder.diameter) meters"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var diameterStepper: UIStepper = {
        let stepper = UIStepper(frame: CGRect.zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.value = self.reminder.diameter
        stepper.stepValue = 10
        stepper.minimumValue = 10
        stepper.maximumValue = 500
        stepper.addTarget(self, action: #selector(didUpdateDiameterStepper), for: .valueChanged)
        
        return stepper
    }()
    
    lazy var deleteLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "DELETE"
        label.textColor = UIColor.red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

}

// MARK: - Table view delegate

extension EditTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section, indexPath.row) == (3, 1) {
            let locationTVC = LocationTableViewController(delegate: self, location: self.reminder.location)
            self.navigationController?.pushViewController(locationTVC, animated: true)
        } else if (indexPath.section, indexPath.row) == (5, 0) {
            CDController.sharedInstance.managedObjectContext.delete(self.reminder)
            self.resignFirstResponder()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Reminder state"
        case 1: return "Reminder name"
        case 2: return "Arriving/Departing"
        case 3: return "Location"
        case 4: return "Advanced"
        case 5: return "Danger zone"
        default: return ""
        }
    }
}

// MARK: - Table view data source

extension EditTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
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
            cell.contentView.addSubviews([stateLabel, stateSwitch])
            
            NSLayoutConstraint.activate([
                stateLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                stateLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                stateLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                stateSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                stateSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        case (1, 0):
            cell.contentView.addSubview(nameTextField)
            
            NSLayoutConstraint.activate([
                nameTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                nameTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                nameTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                nameTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            ])
        case (2, 0):
            cell.contentView.addSubviews([arrivingStateLabel, arrivingStateSwitch])
            
            NSLayoutConstraint.activate([
                arrivingStateLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                arrivingStateLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                arrivingStateLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                arrivingStateSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                arrivingStateSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        case (3, 0):
            cell.contentView.addSubview(locationNameTextField)
            
            NSLayoutConstraint.activate([
                locationNameTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                locationNameTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                locationNameTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationNameTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            ])
        case (3, 1):
            cell.contentView.addSubview(locationLabel)
            cell.accessoryType = .disclosureIndicator
            
            NSLayoutConstraint.activate([
                locationLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                locationLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            ])
        case (4, 0):
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
        case (5, 0):
            cell.contentView.addSubview(deleteLabel)
            
            NSLayoutConstraint.activate([
                deleteLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                deleteLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                deleteLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                deleteLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            ])
        default:
            break
        }
        return cell
    }
}

// MARK: - Helper methods

extension EditTableViewController: LocationDelegate {
    func setLocation(_ location: CLLocation, andName name: String) {
        self.locationLabel.text = name
        self.location = location
    }
    
    @objc func didUpdateStateSwitch(sender: UISwitch) {
        if sender.isOn {
            self.stateLabel.text = "Active"
        } else {
            self.stateLabel.text = "Disabled"
        }
    }
    
    @objc func didUpdateArrivingSwitch(sender: UISwitch) {
        if sender.isOn {
            self.arrivingStateLabel.text = "Arriving"
        } else {
            self.arrivingStateLabel.text = "Departing"
        }
    }
    
    @objc func didUpdateDiameterStepper(sender: UIStepper) {
        self.diameterValueLabel.text = "\(sender.value) meters"
    }
    
    @objc func saveReminder() {
        guard let name = nameTextField.text, let locationName = locationNameTextField.text, locationNameTextField.text != "", nameTextField.text != "" else {
            let alertController = UIAlertController(title: "Name fields can't be empty!", message: "Please be sure that both Reminder Name and Location Name are not empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        //Disable the reminder first to remove the current UNTrigger
        reminder.disable()
        
        reminder.isActive = stateSwitch.isOn
        if stateSwitch.isOn {
            //Re-add the UNTrigger
            reminder.enable()
        } else {
            //Re-delete the UNTrigger just to be sure
            reminder.disable()
        }
        reminder.name = name
        reminder.ariving = arrivingStateSwitch.isOn
        reminder.locName = locationName
        reminder.lat = self.location.coordinate.latitude
        reminder.long = self.location.coordinate.longitude
        reminder.diameter = diameterStepper.value
        
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel() {
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
}












