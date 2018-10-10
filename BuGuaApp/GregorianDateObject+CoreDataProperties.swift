//
//  GregorianDateObject+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-08.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import CoreData
import Foundation

extension GregorianDateObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GregorianDateObject> {
        return NSFetchRequest<GregorianDateObject>(entityName: "GregorianDateObject")
    }

    @NSManaged public var day: Int64
    @NSManaged public var month: Int64
    @NSManaged public var year: Int64
    @NSManaged public var recordData: NSData?
    @NSManaged public var recordName: String?
    @NSManaged public var buGuaEntry: BuGuaEntryObject
}
