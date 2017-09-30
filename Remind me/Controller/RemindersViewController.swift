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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("woah!")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
