//
//  GregorianDateObject+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-12.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import CoreData
import Foundation

extension GregorianDateObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GregorianDateObject> {
        return NSFetchRequest<GregorianDateObject>(entityName: "GregorianDateObject")
    }

    @NSManaged public var recordName: String?
    @NSManaged public var recordId: NSData?
    @NSManaged public var year: Int64
    @NSManaged public var month: Int64
    @NSManaged public var day: Int64
    // TODO: Change this back to required
    @NSManaged public var entry: BuGuaEntryObject?
}
