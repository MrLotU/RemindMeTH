//
//  Extensions.swift
//  Remind me
//
//  Created by Jari Koopman on 03/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}
