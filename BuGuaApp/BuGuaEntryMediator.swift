//
//  BuGuaEntryMediator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
import BuGuaKit
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class BuGuaEntryMediator: Mediator {
    typealias ManagedObject = BuGuaEntryObject
    let bag = DisposeBag()
    let input = PublishRelay<BuGuaEntry>()
    private(set) lazy var output = buGuaEntryOutput.asDriver()
    let buGuaEntryObject: BuGuaEntryObject
    let storageManager: StorageManager
    private let buGuaEntryOutput = BehaviorRelay<BuGuaEntry>(value: .default)
    required init(immutable structElement: BuGuaEntry, storageManager: StorageManager) {
        buGuaEntryObject = storageManager.makeObject(from: structElement)
        self.storageManager = storageManager
        update(with: structElement)
    }

    required init(object: BuGuaEntryObject, storageManager: StorageManager) {
        buGuaEntryObject = object
        self.storageManager = storageManager
        sendUpdateNotification()
    }

    func reactiveBinding() {
        input.bind { [unowned self] entry in
            self.update(with: entry)
        }.disposed(by: bag)
    }

    func update(with structure: BuGuaEntry) {
        buGuaEntryObject.managedObjectContext?.perform {
            self.buGuaEntryObject.update(with: structure)
            self.storageManager.saveContext()
            self.sendUpdateNotification()
        }
    }

    func sendUpdateNotification() {
        //        let test = CKRecord(recordType: "Test", recordID: .init(recordName: obj.objectID))
        buGuaEntryOutput.accept(buGuaEntryObject.immutable())
    }
}

extension AppFactory {
    func makeBuGuaEntryMediator(_ immutable: BuGuaEntry) -> BuGuaEntryMediator {
        return BuGuaEntryMediator(immutable: immutable, storageManager: storageManager)
    }
}
