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
}

extension Location {
    @NSManaged var lat: Double
    @NSManaged var lon: Double
    @NSManaged var name: String
}
