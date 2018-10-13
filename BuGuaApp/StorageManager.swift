//
//  StorageManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
import CoreData
import Foundation

class StorageManager {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func makeObject<Immutable>(from immutable: Immutable) -> Immutable.ObjectType where Immutable: ManagedConvertable, Immutable.Context == NSManagedObjectContext {
        return immutable.managedObject(inConext: context)
    }

    func saveContext() {}
}
