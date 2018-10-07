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
    private let cacheManager: CacheManager

    init(container: CKContainer, zone: CKRecordZone, cacheManager: CacheManager) {
        self.container = container
        self.zone = zone
        self.cacheManager = cacheManager
    }
}
