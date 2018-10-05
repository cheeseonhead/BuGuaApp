//
//  StorageManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CloudKit
import Foundation
import CoreData

protocol CloudKitManagedObject {
    var recordType: String { get }

    func ckRecord(zoneID: CKRecordZone.ID) -> CKRecord
}

extension BuGuaEntryObject: CloudKitManagedObject {

    var recordType: String {
        return "BuGuaEntryObject"
    }

    func ckRecord(zoneID: CKRecordZone.ID) -> CKRecord {
        let cloudRecord = cloudKitRecord(zoneID: zoneID)
        cloudRecord["name"] = name as CKRecordValue?

        return cloudRecord
    }
}

extension CloudKitManagedObject where Self: NSManagedObject {

    var recordType: String {
        fatalError("Please implement this")
    }

    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord {
        return CKRecord(recordType: recordType, recordID: cloudKitRecordID(zoneID: zoneID))
    }

    func cloudKitRecordID(zoneID: CKRecordZone.ID) -> CKRecord.ID {
        return CKRecord.ID(recordName: objectID.uriRepresentation().absoluteString, zoneID: zoneID)
    }
}

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

            let insertedObjects = self.context.insertedObjects
            let modifiedObjects = self.context.updatedObjects
            let deletedRecordIDs = self.context.deletedObjects.map {
                ($0 as! CloudKitManagedObject & NSManagedObject).cloudKitRecordID(zoneID: self.cloudManager.zone.zoneID)
            }

            do {
                try self.context.save()
            } catch {
                fatalError(error.localizedDescription)
            }

            let insertedObjectIDs = insertedObjects.map { $0.objectID }
            let modifiedObjectIDs = modifiedObjects.map { $0.objectID }
            self.cloudManager.update(addedIds: insertedObjectIDs, modifiedIds: modifiedObjectIDs, deleted: deletedRecordIDs)
        }
    }
}
