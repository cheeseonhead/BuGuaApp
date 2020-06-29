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
    var recordID: CKRecord.ID? { get }

    // MARK: - Send to Cloud

    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord
    func fillCloudRecord(_ record: CKRecord)

    // MARK: - Update from Cloud

    func updateWithRecord(_ record: CKRecord)
    func updateDetails(with record: CKRecord)
}

extension CKRecordConvertable where Self: NSManagedObject {
    // MARK: - Computed Properties

    var recordID: CKRecord.ID? {
        guard let data = recordData else { return nil }

        return (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! CKRecord.ID)
    }

    // MARK: - Send to Cloud

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

            // store this metadata on your local object
            recordData = systemFieldData(for: record)
            recordName = record.recordID.recordName

            fillCloudRecord(record)
            return record
        }
    }

    // MARK: - Update from Cloud

    func updateWithRecord(_ record: CKRecord) {
        recordName = record.recordID.recordName
        recordData = systemFieldData(for: record)

        updateDetails(with: record)
    }

    // MARK: - Helpers

    func generateRecordID(zoneID: CKRecordZone.ID) -> CKRecord.ID {
        let uuid = UUID()
        let recordName = recordType() + "." + uuid.uuidString

        return CKRecord.ID(recordName: recordName, zoneID: zoneID)
    }

    func systemFieldData(for record: CKRecord) -> NSData {
        let data = NSMutableData()
        let coder = NSKeyedArchiver(forWritingWith: data)
        coder.requiresSecureCoding = true
        record.encodeSystemFields(with: coder)
        coder.finishEncoding()

        return data
    }

    func recordType() -> String {
        return String(describing: type(of: self))
    }
}
