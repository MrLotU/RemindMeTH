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
}

extension Reminder {
    @NSManaged var ariving: Bool
    @NSManaged var isActive: Bool
    @NSManaged var diameter: Double
    @NSManaged var name: String
    
}
