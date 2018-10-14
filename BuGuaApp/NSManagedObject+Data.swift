//
//  NSManagedObject+Data.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-08.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CoreData
import Foundation

extension NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
}
