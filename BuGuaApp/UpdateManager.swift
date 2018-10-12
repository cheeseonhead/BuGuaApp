//
//  UpdateManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-12.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CoreData
import Foundation

class UpdateManager {
    let updateContext: NSManagedObjectContext

    init(updateContext: NSManagedObjectContext) {
        self.updateContext = updateContext
    }
}
