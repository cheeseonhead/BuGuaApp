//
//  StorageManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init(container: NSPersistentContainer, context: NSManagedObjectContext) {
        self.container = container
        self.context = context
    }
}
