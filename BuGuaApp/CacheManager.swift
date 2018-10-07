//
//  CacheManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CoreData
import Foundation

class CacheManager {
    private let context: NSManagedObjectContext
    private let dateGenerator: () -> NSDate

    init(context: NSManagedObjectContext, dateGenerator: @escaping () -> NSDate) {
        self.context = context
        self.dateGenerator = dateGenerator
    }

    func cacheUpdate(ids: [NSManagedObjectID]) {
        let uris = ids.map { $0.uriRepresentation() }

        context.perform { [unowned self] in
            uris.forEach {
                let cacheObject = CacheRecord(context: self.context)
                cacheObject.managedObjectId = $0
                cacheObject.nextTryTimestamp = self.dateGenerator()
            }
            try! self.context.save()
        }
    }
}
