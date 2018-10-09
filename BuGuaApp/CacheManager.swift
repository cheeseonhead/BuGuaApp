//
//  CacheManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CloudKit
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

    func getCached(_ completion: @escaping ([CKRecordConvertable]) -> Void) {
        let request = NSFetchRequest<CacheRecord>(entityName: CacheRecord.entityName)
        request.predicate = NSPredicate(format: "\(#keyPath(CacheRecord.nextTryTimestamp)) < %@", NSDate())
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CacheRecord.nextTryTimestamp), ascending: true)]

        context.perform { [unowned self] in
            let records = try! self.context.fetch(request)
            let urls = records.map { $0.managedObjectId }
            let objectIds = urls.map { (url) -> NSManagedObjectID in
                return self.context.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: url)!
            }

            var objects = [CKRecordConvertable]()

            for id in objectIds {
                if let obj = try? self.context.existingObject(with: id) {
                    guard let ckObj = obj as? CKRecordConvertable else {
                        fatalError("Attempting to upload an entity that's not compatible with CloudKit")
                    }

                    objects.append(ckObj)
                } else {
                    // TODO: handle the delete case
                    continue
                }
            }

            completion(objects)
        }
    }

    func saveUpdates(ckRecords: [CKRecord], deletedIds _: [CKRecord.ID]) {
        let recordNames = ckRecords.map {
            $0.recordID.recordName
        }

        context.perform {
            for recordName in recordNames {}
        }

        // TODO: Handle deletion
    }
}
