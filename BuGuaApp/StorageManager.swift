//
//  StorageManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
import CoreData
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class StorageManager {
    // MARK: - Inputs

    let bag = DisposeBag()
    private(set) var childContextSaveInput = PublishRelay<()>()

    // MARK: - Dependencies

    private let context: NSManagedObjectContext
    private let cacheManager: CacheManager

    init(cacheManager: CacheManager, context: NSManagedObjectContext) {
        self.context = context
        self.cacheManager = cacheManager

        childContextSaveInput.bind { [unowned self] _ in
            self.context.perform {
                print("Child Context saved\n")
                try! self.context.save()
                print("Saved context\n")
            }
        }.disposed(by: bag)
    }

    func makeObject<Immutable>(from immutable: Immutable) -> Immutable.ObjectType where Immutable: ManagedConvertable, Immutable.Context == NSManagedObjectContext {
        return immutable.managedObject(inConext: context)
    }

    func saveContext() {
        context.perform { [unowned self] in
            let insertedObjects = self.context.insertedObjects
            let modifiedObjects = self.context.updatedObjects
            let deletedRecordIDs = self.context.deletedObjects.map { obj -> NSData? in
                guard let ckConvertable = obj as? CKRecordConvertable else { return nil }
                return ckConvertable.recordData
            }

            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
                let insertedObjectIDs = insertedObjects.map { $0.objectID }
                let modifiedObjectIDs = modifiedObjects.map { $0.objectID }
                self.cacheManager.cacheUpdate(ids: insertedObjectIDs + modifiedObjectIDs, deleteIds: deletedRecordIDs)
            }
        }
    }
}
