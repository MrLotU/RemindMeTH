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
import UserNotifications

class Reminder: NSManagedObject {
    static let entityName = "\(Reminder.self)"
    
    static var allRemindersRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Reminder.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }()
    
    class func reminderWith(name: String, location: CLLocation, locationName: String, diameter: Double?, isActive: Bool, ariving: Bool) -> Reminder {
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
        
        return reminder
    }
    
    func createReminder() {
        let region = CLCircularRegion(center: self.location.coordinate, radius: self.diameter/2, identifier: "\(self.name)-\(self.locName)")
        
        region.notifyOnEntry = self.ariving
        region.notifyOnExit = !self.ariving
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let content = UNMutableNotificationContent()
        if self.ariving {
            content.title = "Arrived at \(self.locName)"
        } else {
            content.title = "Departed from \(self.locName)"
        }
        content.badge = 1
        content.body = self.name
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: region.identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
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
    
    func disable() {
        self.isActive = false
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.identifier == "\(self.name)-\(self.locName)" {
                    center.removePendingNotificationRequests(withIdentifiers: ["\(self.name)-\(self.locName)"])
                }
            }
        }
    }
    
    func enable() {
        self.isActive = true
        let center = UNUserNotificationCenter.current()
        var foundReminderForID = false
        center.getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.identifier == "\(self.name)-\(self.locName)" {
                    foundReminderForID = true
                }
            }
        }
        if !foundReminderForID {
            self.createReminder()
        }
    }
    
    var location: CLLocation {
        return CLLocation(latitude: self.lat, longitude: self.long)
    }
}
