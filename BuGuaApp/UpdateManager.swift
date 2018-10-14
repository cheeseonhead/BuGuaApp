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

class UpdateManager {
    let updateContext: NSManagedObjectContext

    init(updateContext: NSManagedObjectContext) {
        self.updateContext = updateContext
    }

    /// This method is called when a record has been updated from the cloud
    func recordUpdated(_ record: CKRecord) {
        updateContext.perform {
            if let correspondingObject = self.retrieveRecordConvertable(for: record.recordID.recordName) {
                correspondingObject.updateWithRecord(record)
            } else {
                let newObject = NSEntityDescription.insertNewObject(forEntityName: record.recordType, into: self.updateContext)

                guard let r = newObject as? CKRecordConvertable else { return }
                r.updateWithRecord(record)
            }

            try! self.updateContext.save()
        }
    }

    /// This method is called when a record has been deleted from the cloud
    func recordDeleted(_ recordID: CKRecord.ID) {
        updateContext.perform {
            if let correspondingObject = self.retrieveObject(for: recordID.recordName) {
                self.updateContext.delete(correspondingObject)
            }

            try! self.updateContext.save()
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
