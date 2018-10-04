//
//  BuGuaEntryMediator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import CoreData
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

protocol Migratable: Equatable {
    associatedtype Counterpart
    associatedtype Context

    static func build(from: Counterpart) -> Self?
    func export(toContext:Context) -> Counterpart
//    static func delete(counterpart:Counterpart, fromContext:Context) throws
}

protocol Mediator {
    associatedtype ManagedObject
    associatedtype StructElement: Migratable where StructElement.Counterpart == ManagedObject

    init(structElement: StructElement, storageManager: StorageManager) throws
    init(object: ManagedObject, storageManager: StorageManager)

    var input: PublishRelay<StructElement> { get }
    var output: Driver<StructElement> { get }
}

extension BuGuaEntry: Migratable {
    typealias Counterpart = BuGuaEntryObject
    typealias Context = NSManagedObjectContext


    static func build(from object: BuGuaEntryObject) -> BuGuaEntry? {
        let builder = BuGuaEntryBuilder()

        builder.setDate(GregorianDate(year: Int(object.date!.year), month: Int(object.date!.month), day: Int(object.date!.day)))
        builder.setName(object.name!)
        builder.setGuaXiang(.default)
        builder.setTime(.zero)

        return builder.build()
    }

    func export(toContext: NSManagedObjectContext) -> BuGuaEntryObject {
        let object = BuGuaEntryObject(context: toContext)
        let dateObject = GregorianDateObject(context: toContext)
        dateObject.year = Int64(date.year)
        dateObject.month = Int64(date.month)
        dateObject.day = Int64(date.day)
        object.name = name
        object.date = dateObject

        return object
    }

}

class BuGuaEntryMediator: Mediator {
    typealias StructElement = BuGuaEntry

    let input = PublishRelay<BuGuaEntry>()
    private (set) lazy var output = buGuaEntryOutput.asDriver()

    let buGuaEntryObject: BuGuaEntryObject
    let storageManager: StorageManager

    private let buGuaEntryOutput = BehaviorRelay<BuGuaEntry>(value: .default)

    required init(structElement: BuGuaEntry, storageManager: StorageManager) {
        buGuaEntryObject = structElement.export(toContext: storageManager.context)
        self.storageManager = storageManager

        update(obj: buGuaEntryObject)
    }

    required init(object: BuGuaEntryObject, storageManager: StorageManager) {
        self.buGuaEntryObject = object
        self.storageManager = storageManager

        update(obj: buGuaEntryObject)
    }

    func update(obj: BuGuaEntryObject) {
        buGuaEntryOutput.accept(BuGuaEntry.build(from: obj)!)
    }
}

extension AppFactory {
    func makeBuGuaEntryMediator(_ structElement: BuGuaEntry) -> BuGuaEntryMediator {
        return BuGuaEntryMediator(structElement: structElement, storageManager: storageManager)
    }
}

extension BuGuaEntry {
    static let `default` = {
        BuGuaEntryBuilder()
            .setDate(.zero)
            .setTime(.zero)
            .setGuaXiang(.default)
            .build()
    }()
}
