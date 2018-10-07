//
//  CacheManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-06.
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
        let strIds = ids.map { $0.uriRepresentation().absoluteString }

        context.perform { [unowned self] in

            strIds.forEach {
                let cacheObject = CachedRecord(context: self.context)
                cacheObject.modifiedObjectId = $0
                cacheObject.nextTryTimestamp = self.dateGenerator()
            }

            try! self.context.save()
        }
    }
}
