//
//  CKRecordConvertable.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-08.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CloudKit
import CoreData
import Foundation

protocol CKRecordConvertable {
    var ckData: NSData? { get set }

    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord

    func fillCloudRecord(_ record: CKRecord)
}

extension CKRecordConvertable where Self: NSManagedObject {
    func recordType() -> String {
        return String(describing: type(of: self))
    }

    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord {
        if let ckData = ckData {
            // set up the CKRecord with its metadata
            let coder = NSKeyedUnarchiver(forReadingWith: ckData as Data)
            coder.requiresSecureCoding = true
            let record = CKRecord(coder: coder)!
            coder.finishDecoding()

            fillCloudRecord(record)

            return record

        } else {
            let record = CKRecord(recordType: recordType(), recordID: cloudKitRecordID(zoneID: zoneID))
            fillCloudRecord(record)
            return record
        }
    }

    func cloudKitRecordID(zoneID: CKRecordZone.ID) -> CKRecord.ID {
        return CKRecord.ID(recordName: objectID.uriRepresentation().absoluteString, zoneID: zoneID)
    }
}
