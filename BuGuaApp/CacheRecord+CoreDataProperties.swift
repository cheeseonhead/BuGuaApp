//
//  CacheRecord+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import CoreData
import Foundation

extension CacheRecord {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CacheRecord> {
        return NSFetchRequest<CacheRecord>(entityName: "CacheRecord")
    }

    @NSManaged public var managedObjectId: URL?
    @NSManaged public var nextTryTimestamp: NSDate
    @NSManaged public var recordId: NSData?
}
