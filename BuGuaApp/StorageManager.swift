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
    let cloudManager: CloudKitManager
    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init(container: NSPersistentContainer, context: NSManagedObjectContext, cloudManager: CloudKitManager) {
        self.container = container
        self.context = context
        self.cloudManager = cloudManager
    }

    func saveContext() {
        context.perform { [unowned self] in
            do {
                try self.context.save()
            } catch {
                fatalError(error.localizedDescription)
            }


        }
    }
}
