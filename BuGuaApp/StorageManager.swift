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
}

extension NSManagedObject: CloudKitManagedObject {

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
    private let cloudManager: CloudKitManager
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    init(container: NSPersistentContainer, context: NSManagedObjectContext, cloudManager: CloudKitManager) {
        self.container = container
        self.context = context
        self.cloudManager = cloudManager
    }

    func makeObject<Immutable>(from immutable: Immutable) -> Immutable.ObjectType where Immutable: ManagedConvertable, Immutable.Context == NSManagedObjectContext {
        return immutable.managedObject(inConext: context)
    }

    func saveContext() {
        context.perform { [unowned self] in

            let insertedObjects = self.context.insertedObjects
            let modifiedObjects = self.context.updatedObjects
            let deletedRecordIDs = self.context.deletedObjects.map { self.cloudManager.cloudRecordId(for: $0) }

            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    fatalError(error.localizedDescription)
                }

                let insertedObjectIDs = insertedObjects.map { $0.objectID }
                let modifiedObjectIDs = modifiedObjects.map { $0.objectID }
                self.cloudManager.update(saveIds: insertedObjectIDs + modifiedObjectIDs, deleteIds: deletedRecordIDs)
            }
        }
    }
}
