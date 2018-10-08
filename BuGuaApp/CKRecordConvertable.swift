//
//  CKRecordConvertable.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-08.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CloudKit
import Foundation

protocol CKRecordConvertable {
    func recordType() -> String
    func fillCloudRecord(_ record: CKRecord)
    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord
    func cloudKitRecordID(zoneID: CKRecordZone.ID) -> CKRecord.ID
}
