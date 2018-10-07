//
//  ManagedConvertable.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import CoreData

protocol ManagedConvertable {
    associatedtype Context
    associatedtype ObjectType: ImmutableConvertable where ObjectType.Context == Context

    func managedObject(inConext context: NSManagedObjectContext) -> ObjectType
}

extension ManagedConvertable where Self == ObjectType.ImmutableType {
    func managedObject(inConext context: Context) -> ObjectType {
        return ObjectType.build(from: self, inContext: context)
    }
}
