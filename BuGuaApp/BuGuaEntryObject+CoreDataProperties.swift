//
//  BuGuaEntryObject+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import Foundation
import CoreData


extension BuGuaEntryObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuGuaEntryObject> {
        return NSFetchRequest<BuGuaEntryObject>(entityName: "BuGuaEntryObject")
    }

    @NSManaged public var name: String
    @NSManaged public var date: GregorianDateObject

}
