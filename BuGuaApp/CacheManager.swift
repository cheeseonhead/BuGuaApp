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
    // MARK: - Constant

    let matureCacheFetchLimit = 1

    // MARK: - Dependencies

    private let context: NSManagedObjectContext
    private let dateGenerator: () -> NSDate

    init(context: NSManagedObjectContext, dateGenerator: @escaping () -> NSDate) {
        self.context = context
        self.dateGenerator = dateGenerator
    }

    /// Call this method if there are managed objects that have been modified and should be uploaded to the cloud at
    /// a later time.
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

    /// Call this method to get all the objects that are waiting to be uploaded
    func getCached(_ completion: @escaping ([CKRecordConvertable]) -> Void) {
        context.perform { [unowned self] in
            let objectIds = self.fetchAllMatureCacheRecords()
                .map { $0.managedObjectId }
                .map { (url) -> NSManagedObjectID in
                    return self.context.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: url)!
                }

            var objects = [CKRecordConvertable]()

            for id in objectIds {
                if let obj = try? self.context.existingObject(with: id) {
                    guard let ckObj = obj as? CKRecordConvertable else {
                        fatalError("Attempting to upload an entity (\(obj.entity.name!)) that's not compatible with CloudKit")
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

    /// This method is called when a record has been updated from the cloud
    func recordUpdated(_ record: CKRecord) {
        context.perform {
            if let correspondingObject = self.retrieveObject(for: record.recordID.recordName) {
                correspondingObject.updateWithRecord(record)
            } else {
                let newObject = NSEntityDescription.insertNewObject(forEntityName: record.recordType, into: self.context)

                guard let r = newObject as? CKRecordConvertable else { return }
                r.updateWithRecord(record)
            }

            try! self.context.save()
        }
    }

    /// This method is called when a record upload result has come back
    func handleRecordUploadResult(_ record: CKRecord, error _: Error?) {
        // TODO: Handle error

        context.perform {
            guard let correspondingObject = self.retrieveObject(for: record.recordID.recordName) else {
                fatalError("Trying to handle a record uploaded that doesn't exist locally")
            }

            correspondingObject.updateWithRecord(record)

            if let managedObject = correspondingObject as? NSManagedObject {
                self.deleteCaches(for: managedObject)
            }

            try! self.context.save()
        }
    }

    /// This method is called when the whole operation finished
    func handleRecordDeletionResult(_: [CKRecord.ID]?, error _: Error?) {
        // TODO: Handle deletion
        // If anything failed, just create another CacheRecord.
    }
}

private extension CacheManager {
    func retrieveObject(for recordName: String) -> CKRecordConvertable? {
        guard let dotIndex = recordName.index(of: ".") else { return nil }
        let entityName = String(recordName.prefix(upTo: dotIndex))

        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "recordName == %@", recordName)

        let result = try! context.fetch(request)

        guard result.count > 0, let r = result[0] as? CKRecordConvertable else { return nil }
        return r
    }

    func fetchAllMatureCacheRecords() -> [CacheRecord] {
        let request = NSFetchRequest<CacheRecord>(entityName: CacheRecord.entityName)
        request.predicate = NSPredicate(format: "\(#keyPath(CacheRecord.nextTryTimestamp)) < %@", NSDate())
        request.fetchLimit = matureCacheFetchLimit
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CacheRecord.nextTryTimestamp), ascending: true)]

        return try! context.fetch(request)
    }

    func deleteCaches(for managedObject: NSManagedObject) {
        let request = NSFetchRequest<CacheRecord>(entityName: CacheRecord.entityName)
        request.predicate = NSPredicate(format: "\(#keyPath(CacheRecord.managedObjectId)) == %@", managedObject.objectID.uriRepresentation() as CVarArg)

        try! context.fetch(request).forEach { cacheRecord in
            self.context.delete(cacheRecord)
        }
    }
}
