//
//  BuGuaEntryObject+CoreDataClass.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-12.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import BuGuaKit
import CoreData
import Foundation

@objc(BuGuaEntryObject)
public final class BuGuaEntryObject: NSManagedObject {}

extension BuGuaEntryObject: ImmutableConvertable {
    typealias ImmutableType = BuGuaEntry
    typealias Context = NSManagedObjectContext

    static func build(from immutable: BuGuaEntry, inContext: NSManagedObjectContext) -> BuGuaEntryObject {
        let object = BuGuaEntryObject(context: inContext)

        object.gregorianDate = immutable.date.managedObject(inConext: inContext)

        return object
    }

    func immutable() -> BuGuaEntry {
        return BuGuaEntryBuilder()
            .setDate(gregorianDate.immutable())
            .build()
    }

    func update(with immutable: BuGuaEntry) {
        gregorianDate.update(with: immutable.date)
    }
}

extension BuGuaEntry: ManagedConvertable {
    typealias Context = NSManagedObjectContext
    typealias ObjectType = BuGuaEntryObject
}
