//
//  CacheRecord+CoreDataClass.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-12.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import CloudKit
import CoreData
import Foundation

@objc(CacheRecord)
public class CacheRecord: NSManagedObject {
    var recordID: CKRecord.ID? {
        guard let data = recordData else { return nil }

        return (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! CKRecord.ID)
    }
}
