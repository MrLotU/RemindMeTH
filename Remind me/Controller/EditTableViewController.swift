//
//  EditTableViewController.swift
//  Remind me
//
//  Created by Jari Koopman on 03/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController {
    
    fileprivate let reminder: Reminder
    
    init(reminder: Reminder) {
        self.reminder = reminder
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveReminder))
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
    
    lazy var nameTextView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.text = self.reminder.name
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
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
    
    lazy var locationNameTextView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.text = self.reminder.location.name
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
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
        stepper.stepValue = 5
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.addTarget(self, action: #selector(didUpdateDiameterStepper), for: .valueChanged)
        
        return stepper
    }()

}

// MARK: - Table view delegate

extension EditTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

// MARK: - Table view data source

extension EditTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
                
                stateSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ])
        case (1, 0):
            cell.contentView.addSubview(nameTextView)
            
            NSLayoutConstraint.activate([
                nameTextView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                nameTextView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                nameTextView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                nameTextView.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            ])
        case (2, 0):
            cell.contentView.addSubviews([arrivingStateLabel, arrivingStateSwitch])
            
            NSLayoutConstraint.activate([
                arrivingStateLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                arrivingStateLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                arrivingStateLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                arrivingStateSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ])
        case (3, 0):
            cell.contentView.addSubview(locationNameTextView)
            
            NSLayoutConstraint.activate([
                locationNameTextView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                locationNameTextView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                locationNameTextView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationNameTextView.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            ])
        case (3, 1):
            cell.contentView.addSubview(locationLabel)
            cell.accessoryType = .disclosureIndicator
            
            NSLayoutConstraint.activate([
                locationLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                locationLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            ])
        case (4, 0):
            cell.contentView.addSubviews([diameterLabel, diameterValueLabel, diameterStepper])
            
            NSLayoutConstraint.activate([
                diameterLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                diameterLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                diameterLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                diameterLabel.trailingAnchor.constraint(equalTo: diameterValueLabel.leadingAnchor, constant: 10),
                
                diameterValueLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                diameterValueLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                diameterStepper.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ])
        default:
            break
        }
        return cell
    }
}

// MARK: - Helper methods

extension EditTableViewController {
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
        
    }
    
    @objc func cancel() {
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
}












