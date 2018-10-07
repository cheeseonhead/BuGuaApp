//
//  GregorianDate+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import Foundation
import CoreData


extension GregorianDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GregorianDate> {
        return NSFetchRequest<GregorianDate>(entityName: "GregorianDate")
    }

    @NSManaged public var year: Int64
    @NSManaged public var month: Int64
    @NSManaged public var day: Int64
    @NSManaged public var buGuaEntry: BuGuaEntry

}
