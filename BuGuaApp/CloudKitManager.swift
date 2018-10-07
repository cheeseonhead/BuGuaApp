//
//  CloudKitManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-04.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CloudKit
import CoreData
import Foundation

protocol CloudKitManagedObject {
    func recordType() -> String
    func fillCloudRecord(_ record: CKRecord)
    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord
    func cloudKitRecordID(zoneID: CKRecordZone.ID) -> CKRecord.ID
}

extension CloudKitManagedObject where Self: NSManagedObject {

    func recordType() -> String {
        return String(describing: type(of: self))
    }

    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord {
        let record = CKRecord(recordType: recordType(), recordID: cloudKitRecordID(zoneID: zoneID))
        fillCloudRecord(record)
        return record
    }

    func cloudKitRecordID(zoneID: CKRecordZone.ID) -> CKRecord.ID {
        return CKRecord.ID(recordName: objectID.uriRepresentation().absoluteString, zoneID: zoneID)
    }
}

class CloudKitManager {

    enum State {
        case initialized

        case loggedIn, loginError(Error), notLoggedIn, couldNotDetermine, restricted

        case zoneAdded
    }

    // MARK: - Public
    private (set) var state = State.initialized {
        didSet {
            print(String(describing: state))
        }
    }

    // MARK: - Dependencies
    private let container: CKContainer
    private let zone: CKRecordZone
    private let cacheManager: CacheManager

    // MARK: - Private
    private let timer: RepeatingTimer

    init(container: CKContainer, zone: CKRecordZone, cacheManager: CacheManager) {
        self.container = container
        self.zone = zone
        self.cacheManager = cacheManager

        timer = RepeatingTimer(timeInterval: 5)
        timer.eventHandler = { [unowned self] in
            self.loop()
        }
        timer.resume()

        loop()
    }

    func loop() {
        switch state {
        case .initialized: checkLoginStatus()
        case .loggedIn: addZone()
        case .notLoggedIn, .couldNotDetermine, .restricted, .loginError: checkLoginStatus()
        case .zoneAdded: uploadCache()
        }
    }

    /// Should be called when at states before loggedIn.
    func checkLoginStatus() {
        container.accountStatus { [unowned self] (status, error) in
            if let error = error {
                self.state = .loginError(error)
            } else {
                switch status {
                case .available:
                    self.state = .loggedIn
                    self.addZone()
                case .noAccount:
                    self.state = .notLoggedIn
                case .couldNotDetermine:
                    self.state = .couldNotDetermine
                case .restricted:
                    self.state = .restricted
                }
            }
        }
    }

    func addZone() {
        let zonesToSave = [zone]
        let zoneOperation = CKModifyRecordZonesOperation(recordZonesToSave: zonesToSave, recordZoneIDsToDelete: nil)

        zoneOperation.configuration.container = container

        zoneOperation.modifyRecordZonesCompletionBlock = { [unowned self] savedZones, _, error in
            if savedZones?.contains(self.zone) ?? false {
                self.state = .zoneAdded
            }
        }

        zoneOperation.start()
    }

    func uploadCache() {
        cacheManager.getCached { [unowned self] objects in
            let records = objects.map {
                $0.cloudKitRecord(zoneID: self.zone.zoneID)
            }

            let recordOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            recordOperation.configuration.container = self.container
            recordOperation.database = self.container.privateCloudDatabase
            recordOperation.perRecordCompletionBlock = { record, error in
                print(error?.localizedDescription)
                print(record)
            }

            recordOperation.start()
        }
    }
}
