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
            try! self.context.save()
            completion(objects)
        }
    }

    func saveUpdates(ckRecords: [CKRecord], deletedIds _: [CKRecord.ID]) {
        context.perform {
            for record in ckRecords {
                guard let correspondingObject = self.retrieveObject(for: record.recordID.recordName) else {
                    continue
                }

                correspondingObject.updateWithRecord(record)
            }

            try! self.context.save()
        }

        // TODO: Handle deletion
    }
}

private extension CacheManager {
    func retrieveObject(for recordName: String) -> CKRecordConvertable? {
        guard let dotIndex = recordName.index(of: ".") else { return nil }
        let entityName = String(recordName.prefix(upTo: dotIndex))

        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "recordName == %@", recordName)

        do {
            guard let r = try context.fetch(request)[0] as? CKRecordConvertable else { return nil }
            return r
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
