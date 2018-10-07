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

    private let container: CKContainer
    private let zone: CKRecordZone
    private let context: NSManagedObjectContext
    private let dateGenerator: () -> NSDate

    init(container: CKContainer, zone: CKRecordZone, context: NSManagedObjectContext, dateGenerator: @escaping () -> NSDate) {
        self.container = container
        self.zone = zone
        self.context = context
        self.dateGenerator = dateGenerator
    }

    func cloudRecordId(for managedObject: NSManagedObject) -> CKRecord.ID {
        return managedObject.cloudKitRecordID(zoneID: zone.zoneID)
    }

    func update(saveIds: [NSManagedObjectID], deleteIds: [CKRecord.ID]) {
        let strIds = saveIds.map { $0.uriRepresentation().absoluteString }

        context.perform { [unowned self] in

            strIds.forEach { [unowned self] in
                let cacheObject = CachedRecord(context: self.context)
                cacheObject.modifiedObjectId = $0
                cacheObject.nextTryTimestamp = self.dateGenerator()
            }

            try! self.context.save()
        }
    }
}
