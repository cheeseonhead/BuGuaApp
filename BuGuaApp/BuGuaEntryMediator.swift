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
    func export(toContext:Context) throws -> Counterpart
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


    static func build(from: BuGuaEntryObject) -> BuGuaEntry? {
        return BuGuaEntry.default
    }

    func export(toContext: NSManagedObjectContext) throws -> BuGuaEntryObject {
        return BuGuaEntryObject(context: toContext)
    }

}

class BuGuaEntryMediator: Mediator {
    typealias StructElement = BuGuaEntry

    let input = PublishRelay<BuGuaEntry>()
    private (set) lazy var output = buGuaEntryOutput.asDriver()

    let buGuaEntryObject: BuGuaEntryObject
    let storageManager: StorageManager

    private let buGuaEntryOutput = BehaviorRelay<BuGuaEntry>(value: .default)

    required init(structElement: BuGuaEntry, storageManager: StorageManager) throws {
        buGuaEntryObject = try structElement.export(toContext: storageManager.context)
        self.storageManager = storageManager
    }

    required init(object: BuGuaEntryObject, storageManager: StorageManager) {
        self.buGuaEntryObject = object
        self.storageManager = storageManager
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
