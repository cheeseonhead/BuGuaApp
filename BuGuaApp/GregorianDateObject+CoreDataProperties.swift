//
//  GregorianDateObject+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import Foundation
import CoreData


extension GregorianDateObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GregorianDateObject> {
        return NSFetchRequest<GregorianDateObject>(entityName: "GregorianDateObject")
    }

    @NSManaged public var year: Int64
    @NSManaged public var month: Int64
    @NSManaged public var day: Int64
    @NSManaged public var buGuaEntry: BuGuaEntryObject

}
