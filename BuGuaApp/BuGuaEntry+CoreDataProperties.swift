//
//  BuGuaEntry+CoreDataProperties.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import Foundation
import CoreData


extension BuGuaEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuGuaEntry> {
        return NSFetchRequest<BuGuaEntry>(entityName: "BuGuaEntry")
    }

    @NSManaged public var date: GregorianDate

}
