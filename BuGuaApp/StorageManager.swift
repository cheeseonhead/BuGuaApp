//
//  StorageManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CoreData
import Foundation

class StorageManager {
    private let cacheManager: CacheManager
    private let context: NSManagedObjectContext

    init(cacheManager: CacheManager, context: NSManagedObjectContext) {
        self.cacheManager = cacheManager
        self.context = context
    }
}
