//
//  NewReminderTableViewController.swift
//  Remind me
//
//  Created by Jari Koopman on 03/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NewReminderTableViewController: UITableViewController {

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
        label.text = "Select a location"
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

        // Configure the cell...

        return cell
    }
 
}

// MARK: - Table view delegate
extension NewReminderTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section, indexPath.row) == (4, 0) {
            return 2
        } else {
            return 44
        }
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
extension NewReminderTableViewController {
    @objc func doneButtonPressed() {
        
    }
    
    @objc func cancelButtonPressed() {
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
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
        
    }
}
