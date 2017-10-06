//
//  Reminder.swift
//  Remind me
//
//  Created by Jari Koopman on 29/09/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

class Reminder: NSManagedObject {
    static let entityName = "\(Reminder.self)"
    
    static var allRemindersRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Reminder.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }()
    
    class func reminderWith(name: String, location: CLLocation, locationName: String, diameter: Double?, isActive: Bool, ariving: Bool) {
        let reminder = NSEntityDescription.insertNewObject(forEntityName: Reminder.entityName, into: CDController.sharedInstance.managedObjectContext) as! Reminder
        reminder.ariving = ariving
        reminder.isActive = isActive
        if let diameter = diameter {
            reminder.diameter = diameter
        } else {
            reminder.diameter = 50.0
        }
        reminder.name = name
        reminder.lat = location.coordinate.latitude
        reminder.long = location.coordinate.longitude
        reminder.locName = locationName
    }
}

extension Reminder {
    @NSManaged var ariving: Bool
    @NSManaged var isActive: Bool
    @NSManaged var diameter: Double
    @NSManaged var name: String
    @NSManaged var lat: Double
    @NSManaged var long: Double
    @NSManaged var locName: String
    
    var location: CLLocation {
        return CLLocation(latitude: self.lat, longitude: self.long)
    }
}
