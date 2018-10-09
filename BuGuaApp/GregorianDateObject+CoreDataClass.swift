//
//  GregorianDateObject+CoreDataClass.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import BuGuaKit
import CloudKit
import CoreData
import Foundation

@objc(GregorianDateObject)
public final class GregorianDateObject: NSManagedObject {}

extension GregorianDate: ManagedConvertable {
    typealias Context = NSManagedObjectContext
    typealias ObjectType = GregorianDateObject
}

extension GregorianDateObject: ImmutableConvertable {
    typealias Context = NSManagedObjectContext
    typealias ImmutableType = GregorianDate

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

    func update(with immutable: GregorianDate) {
        year = immutable.year.int64
        month = immutable.month.int64
        day = immutable.day.int64
    }
}

extension GregorianDateObject: CKRecordConvertable {
    func fillCloudRecord(_ record: CKRecord) {
        record[.year] = year
        record[.month] = month
        record[.day] = day
    }
}

private extension CKRecord {
    enum Key: String {
        case year, month, day
    }

    subscript(key: Key) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}
