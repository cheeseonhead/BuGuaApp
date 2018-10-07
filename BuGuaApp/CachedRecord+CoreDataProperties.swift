//
//  CachedRecord+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-06.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import Foundation
import CoreData


extension CachedRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedRecord> {
        return NSFetchRequest<CachedRecord>(entityName: "CachedRecord")
    }

    @NSManaged public var modifiedObjectId: UUID?
    @NSManaged public var nextTryTimestamp: NSDate?

}
