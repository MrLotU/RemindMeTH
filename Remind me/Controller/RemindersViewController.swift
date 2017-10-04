//
//  RemindersViewController.swift
//  Remind me
//
//  Created by Jari Koopman on 29/09/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class RemindersViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .grouped)
        
        tableview.register(ReminderTableViewCell.self, forCellReuseIdentifier: "ReminderCell")
        tableview.backgroundColor = UIColor.white
        
        return tableview
    }()
    
    lazy var dataSource: RemindersDataSource = {
        let dataSource = RemindersDataSource(fetchRequest: Reminder.allRemindersRequest, tableView: self.tableView)
        
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for x in 1...30 {
//            let location = Location.locationWith(name: "Location \(x)", andLat: Double(x), andLon: Double(x))
//            Reminder.reminderWith(name: "Reminder \(x)", location: location, diameter: 50, isActive: Bool(x%2 == 0), ariving: Bool(x%2 != 0))
//        }
        
        self.title = "Reminders"
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Add new", style: .plain, target: self, action: #selector(addNewReminder)), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: (view.layoutMargins.top * -0.5)),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

// MARK: - UITableViewDelegate

extension RemindersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReminderTableViewCell
        
        editTableViewCellWithReminder(cell.reminder)
    }
}

// MARK: - Navigation

extension RemindersViewController {
    func editTableViewCellWithReminder(_ reminder: Reminder) {
        let editReminderTVC = EditTableViewController(reminder: reminder)
        self.navigationController?.pushViewController(editReminderTVC, animated: true)
    }
    
    @objc func addNewReminder() {
        let newReminderTVC = NewReminderTableViewController()
        self.navigationController?.pushViewController(newReminderTVC, animated: true)
    }
}








