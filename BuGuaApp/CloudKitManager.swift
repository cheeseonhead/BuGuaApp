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

    init(container: CKContainer, zone: CKRecordZone, context: NSManagedObjectContext) {
        self.container = container
        self.zone = zone
        self.context = context
    }

    func cloudRecordId(for managedObject: NSManagedObject) -> CKRecord.ID {
        return managedObject.cloudKitRecordID(zoneID: zone.zoneID)
    }

    func update(saveIds: [NSManagedObjectID], deleteIds: [CKRecord.ID]) {
        
    }
}
