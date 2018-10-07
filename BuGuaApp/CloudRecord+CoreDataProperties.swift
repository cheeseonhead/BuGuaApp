//
//  CloudRecord+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import Foundation
import CoreData


extension CloudRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CloudRecord> {
        return NSFetchRequest<CloudRecord>(entityName: "CloudRecord")
    }

    @NSManaged public var ckRecordName: URL?
    @NSManaged public var cloudRecord: NSData?

}
