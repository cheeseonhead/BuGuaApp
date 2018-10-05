//
//  CloudKitManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-04.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CloudKit
import CoreData
import Foundation

class CloudKitManager {

    let container: CKContainer
    let zone: CKRecordZone
    let context: NSManagedObjectContext

    init(container: CKContainer, zone: CKRecordZone, context: NSManagedObjectContext) {
        self.container = container
        self.zone = zone
        self.context = context

        let operation = CKModifyRecordZonesOperation(recordZonesToSave: [zone], recordZoneIDsToDelete: nil)
        operation.database = container.privateCloudDatabase
        operation.completionBlock = {
            print("Finished addng zone")
        }
        operation.start()
    }

    func update(addedIds: [NSManagedObjectID], modifiedIds: [NSManagedObjectID], deleted: [CKRecord.ID]) {
        let objects = addedIds.map { try! context.existingObject(with: $0) }

        for object in objects {
            guard let obj = object as? BuGuaEntryObject else { return }

            let record = obj.ckRecord(zoneID: zone.zoneID)

            let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)

            operation.perRecordCompletionBlock = { r, e in
                print(e?.localizedDescription ?? "")
            }
            operation.modifyRecordsCompletionBlock = { _, _, _ in
                print("All done")
            }

            operation.database = self.container.privateCloudDatabase

            operation.start()
        }
    }
}
