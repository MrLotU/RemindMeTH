//
//  RemindersDataSource.swift
//  Remind me
//
//  Created by Jari Koopman on 30/09/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class RemindersDataSource: NSObject {
    fileprivate let tableView: UITableView
    fileprivate let managedObjectContext = CDController.sharedInstance.managedObjectContext
    fileprivate let fetchedResultsController: FetchedResultController

    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, tableView: UITableView) {
        self.tableView = tableView
        
        self.fetchedResultsController = FetchedResultController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, tableView: self.tableView)
        
        super.init()
    }
    
    func performFetch(withPredicate predicate: NSPredicate?) {
        self.fetchedResultsController.performFetch(withPredicate: predicate)
        tableView.reloadData()
    }
}

//MARK: UITableViewDataSource

extension RemindersDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        let reminder = fetchedResultsController.object(at: indexPath) as! Reminder
        
        //TODO: Setup
        
        return cell
    }
}














