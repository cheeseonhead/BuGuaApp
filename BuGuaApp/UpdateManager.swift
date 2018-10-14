//
//  UpdateManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-12.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
import CloudKit
import CoreData
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class UpdateManager {
    // MARK: - Output

    let contextSaveOutput = PublishSubject<()>()

    // MARK: - Dependencies

    private let updateContext: NSManagedObjectContext

    init(updateContext: NSManagedObjectContext) {
        self.updateContext = updateContext
    }

    /// This method is called when a record has been updated from the cloud
    func recordChanged(_ record: CKRecord) {
        print("Update: \(record.recordID.recordName) update received.\n")

        updateContext.perform {
            print("Starting update: \(record.recordID.recordName)\n")

            if let correspondingObject = self.retrieveRecordConvertable(for: record.recordID.recordName) {
                correspondingObject.updateWithRecord(record)
            } else {
                let newObject = NSEntityDescription.insertNewObject(forEntityName: record.recordType, into: self.updateContext)

                guard let r = newObject as? CKRecordConvertable else { return }
                r.updateWithRecord(record)
            }
        }
    }

    /// This method is called when a record has been deleted from the cloud
    func recordDeleted(_ recordID: CKRecord.ID) {
        updateContext.perform {
            if let correspondingObject = self.retrieveObject(for: recordID.recordName) {
                self.updateContext.delete(correspondingObject)
            }
        }
    }

    func flushChanges() {
        updateContext.perform {
            try! self.updateContext.save()

            print("Will send save signal\n")
            self.contextSaveOutput.onNext(())
            print("Did send save signal\n")
        }
    }

    func retrieveObject(for recordName: String) -> NSManagedObject? {
        guard let dotIndex = recordName.index(of: ".") else { return nil }
        let entityName = String(recordName.prefix(upTo: dotIndex))

        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "recordName == %@", recordName)

        let result = try! updateContext.fetch(request)

        guard result.count > 0 else { return nil }
        return result[0]
    }

    func retrieveRecordConvertable(for recordName: String) -> CKRecordConvertable? {
        guard let r = retrieveObject(for: recordName) as? CKRecordConvertable else { return nil }
        return r
    }
}
