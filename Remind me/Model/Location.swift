//
//  Location.swift
//  Remind me
//
//  Created by Jari Koopman on 29/09/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

class Location: NSManagedObject {
    static let entityName = "\(Location.self)"
    
    class func locationWith(name: String, andLat lat: Double, andLon lon: Double) -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: CDController.sharedInstance.managedObjectContext) as! Location
        location.lat = lat
        location.lon = lon
        location.name = name
        
        return location
    }
}

extension Location {
    @NSManaged var lat: Double
    @NSManaged var lon: Double
    @NSManaged var name: String
}
