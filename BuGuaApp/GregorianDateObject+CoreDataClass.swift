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
public final class GregorianDateObject: NSManagedObject {
    func update(with gregorianDate: GregorianDate) {
        year = Int64(gregorianDate.year)
        month = Int64(gregorianDate.month)
        day = Int64(gregorianDate.day)
    }
}

extension GregorianDate: ManagedConvertable {
    typealias Context = NSManagedObjectContext
    typealias ObjectType = GregorianDateObject
}

extension GregorianDateObject: ImmutableConvertable {
    typealias ImmutableType = GregorianDate
    typealias Context = NSManagedObjectContext

    static func build(from immutable: GregorianDate, inContext: NSManagedObjectContext) -> GregorianDateObject {

        let object = GregorianDateObject(context: inContext)

        object.year = immutable.year.int64
        object.month = immutable.month.int64
        object.day = immutable.day.int64

        return object
    }

    func immutable() -> GregorianDate {
        return GregorianDate(year: year.int, month: month.int, day: day.int)
    }

}
