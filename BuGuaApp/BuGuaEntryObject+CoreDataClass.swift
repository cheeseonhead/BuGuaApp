//
//  BuGuaEntryObject+CoreDataClass.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
//

import BuGuaKit
import Foundation
import CoreData

@objc(BuGuaEntryObject)
public final class BuGuaEntryObject: NSManagedObject {
    func update(with entry: BuGuaEntry) {
        name = entry.name
        date.update(with: entry.date)
    }
}

extension BuGuaEntry: ManagedConvertable {
    typealias ObjectType = BuGuaEntryObject
    typealias Context = NSManagedObjectContext
}

extension BuGuaEntryObject: ImmutableConvertable {
    typealias ImmutableType = BuGuaEntry
    typealias Context = NSManagedObjectContext

    static func build(from immutable: BuGuaEntry, inContext: NSManagedObjectContext) -> BuGuaEntryObject {
        let object = BuGuaEntryObject(context: inContext)

        object.name = immutable.name
        object.date = immutable.date.managedObject(inConext: inContext)

        return object
    }

    func immutable() -> BuGuaEntry {
        let builder = BuGuaEntryBuilder()

        return builder.setName(name)
            .setDate(date.immutable())
            .setGuaXiang(.default)
            .build()
    }

}
