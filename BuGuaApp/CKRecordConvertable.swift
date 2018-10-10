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

protocol CKRecordConvertable: class {
    var recordData: NSData? { get set }
    var recordName: String? { get set }

    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord

    func fillCloudRecord(_ record: CKRecord)
}

extension CKRecordConvertable where Self: NSManagedObject {
    func recordType() -> String {
        return String(describing: type(of: self))
    }

    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord {
        if let recordData = recordData {
            // set up the CKRecord with its metadata
            let coder = NSKeyedUnarchiver(forReadingWith: recordData as Data)
            coder.requiresSecureCoding = true
            let record = CKRecord(coder: coder)!
            coder.finishDecoding()

            fillCloudRecord(record)

            return record

        } else {
            let record = CKRecord(recordType: recordType(), recordID: generateRecordID(zoneID: zoneID))

            // obtain the metadata from the CKRecord
            let data = NSMutableData()
            let coder = NSKeyedArchiver(forWritingWith: data)
            coder.requiresSecureCoding = true
            record.encodeSystemFields(with: coder)
            coder.finishEncoding()

            // store this metadata on your local object
            recordData = data

            recordName = record.recordID.recordName

            fillCloudRecord(record)
            return record
        }
    }

    func generateRecordID(zoneID: CKRecordZone.ID) -> CKRecord.ID {
        let uuid = UUID()
        let recordName = recordType() + "." + uuid.uuidString

        return CKRecord.ID(recordName: recordName, zoneID: zoneID)
    }
}
