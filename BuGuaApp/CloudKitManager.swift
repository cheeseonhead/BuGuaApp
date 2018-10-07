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

    func update(ids: [NSManagedObjectID]) {
        let strIds = ids.map { $0.uriRepresentation().absoluteString }

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
