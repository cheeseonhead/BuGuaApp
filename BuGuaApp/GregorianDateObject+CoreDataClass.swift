//
//  GregorianDateObject+CoreDataClass.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import BuGuaKit
import Foundation
import CoreData

@objc(GregorianDateObject)
public class GregorianDateObject: NSManagedObject {
    func update(with gregorianDate: GregorianDate) {
        year = Int64(gregorianDate.year)
        month = Int64(gregorianDate.month)
        day = Int64(gregorianDate.day)
    }
}
