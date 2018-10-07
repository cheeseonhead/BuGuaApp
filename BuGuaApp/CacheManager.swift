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

    func getCached(_ completion: @escaping ([CloudKitManagedObject]) -> Void) {
        let request = NSFetchRequest<CachedRecord>(entityName: "CachedRecord")
        request.predicate = NSPredicate(format: "\(#keyPath(CachedRecord.nextTryTimestamp)) < %@", NSDate())
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CachedRecord.nextTryTimestamp), ascending: true)]

        context.perform { [unowned self] in
            let records = try! self.context.fetch(request)
            let ids = records.map { $0.modifiedObjectId }
            let objectIds = ids.map { (strId) -> NSManagedObjectID in
                let url = URL(string: strId)!
                return self.context.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: url)!
            }

            var objects = [CloudKitManagedObject]()

            for id in objectIds {
                // TODO: handle the delete case
                guard let obj = try? self.context.existingObject(with: id) else {
                    continue
                }

                if let ckObj = obj as? CloudKitManagedObject {
                    objects.append(ckObj)
                }
            }

            completion(objects)
        }
    }
}
