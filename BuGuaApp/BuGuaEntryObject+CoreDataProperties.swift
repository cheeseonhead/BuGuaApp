//
//  BuGuaEntryObject+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-08.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import CoreData
import Foundation

extension BuGuaEntryObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuGuaEntryObject> {
        return NSFetchRequest<BuGuaEntryObject>(entityName: "BuGuaEntryObject")
    }

    @NSManaged public var ckData: NSData?
    @NSManaged public var ckRecordName: String?
    @NSManaged public var date: GregorianDateObject
}
