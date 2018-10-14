//
//  CloudKitManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-07.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//
import CloudKit
import UIKit

class CloudKitManager {
    enum State {
        case initialized

        case loggedIn, loginError(Error), notLoggedIn, couldNotDetermine, restricted

        case inSync, serverOutdated, zoneOutdated
    }

    // MARK: - Public

    private(set) var state = State.initialized {
        didSet {
            print(String(describing: state))
        }
    }

    // MARK: - Dependencies

    private let container: CKContainer
    private let zone: CKRecordZone
    private let cacheManager: CacheManager
    private let updateManager: UpdateManager

    // MARK: - Private

    private let timer: RepeatingTimer

    init(container: CKContainer, zone: CKRecordZone, cacheManager: CacheManager, updateManager: UpdateManager) {
        self.container = container
        self.zone = zone
        self.cacheManager = cacheManager
        self.updateManager = updateManager

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
        case .serverOutdated: fetchUpdates()
        case .zoneOutdated: return
        case .inSync: uploadCache()
        }
    }

    /// Should be called when at states before loggedIn.
    func checkLoginStatus() {
        container.accountStatus { [unowned self] status, error in
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

        zoneOperation.modifyRecordZonesCompletionBlock = { [unowned self] savedZones, _, _ in
            if savedZones?.contains(self.zone) ?? false {
                self.state = .serverOutdated
            }
        }

        zoneOperation.start()
    }

    func fetchUpdates() {
        var latestServerChangeToken = UserDefaults.standard.changeToken(forKey: "serverChangeToken")

        let zoneChangesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: latestServerChangeToken)

        var changedZoneIDs: [CKRecordZone.ID] = []

        zoneChangesOperation.recordZoneWithIDChangedBlock = {
            changedZoneIDs.append($0)
        }

        zoneChangesOperation.changeTokenUpdatedBlock = {
            print("New server token:\($0)")
            latestServerChangeToken = $0
        }

        zoneChangesOperation.fetchDatabaseChangesCompletionBlock = { token, _, error in
            if error != nil {
                // TODO: Handler error
                return
            }

            print("Final new server token:\(token!)")
            latestServerChangeToken = token

            self.fetchZoneChanges(zoneIDs: changedZoneIDs, completion: {
                UserDefaults.standard.setToken(latestServerChangeToken, forKey: "serverChangeToken")
                self.state = .serverOutdated
            })
        }

        container.privateCloudDatabase.add(zoneChangesOperation)
    }

    func fetchZoneChanges(zoneIDs: [CKRecordZone.ID], completion: @escaping () -> Void) {
        // Look up the previous change token for each zone
        var optionsByRecordZoneID = [CKRecordZone.ID: CKFetchRecordZoneChangesOperation.ZoneOptions]()
        for zoneID in zoneIDs {
            let options = CKFetchRecordZoneChangesOperation.ZoneOptions()
            options.previousServerChangeToken = UserDefaults.standard.changeToken(forKey: "TestZoneChangeToken")
            optionsByRecordZoneID[zoneID] = options
        }

        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: zoneIDs, optionsByRecordZoneID: optionsByRecordZoneID)

        operation.recordChangedBlock = { record in
            print("Record changed:", record)
            // Write this record change to memory
            self.updateManager.recordUpdated(record)
        }

        operation.recordWithIDWasDeletedBlock = { recordId, _ in
            print("Record deleted:", recordId)
            // Write this record deletion to memory
        }

        operation.recordZoneFetchCompletionBlock = { zoneId, changeToken, _, _, error in
            if error != nil {
                return
            }
            print("Completion Zone: \(zoneId) Token:\(changeToken!)")
            UserDefaults.standard.setToken(changeToken, forKey: "TestZoneChangeToken")
            // Flush record changes and deletions for this zone to disk
            // Write this new zone change token to disk
        }

        operation.fetchRecordZoneChangesCompletionBlock = { error in
            if error != nil {}
            completion()
        }

        container.privateCloudDatabase.add(operation)
    }

    /// This is called when we are in inSync state. Gets cached records from cacheManager to upload to cloud.
    func uploadCache() {
        cacheManager.getCached { [unowned self] objectsToUpload, recordIDsToDelete in
            let recordsToUpload = objectsToUpload.map {
                $0.cloudKitRecord(zoneID: self.zone.zoneID)
            }

            let recordOperation = CKModifyRecordsOperation(recordsToSave: recordsToUpload, recordIDsToDelete: recordIDsToDelete)

            recordOperation.perRecordCompletionBlock = { record, error in
                if error == nil {
                    print("Record uploaded successfully: \(record)")
                    self.updateManager.recordUpdated(record)
                }
                // TODO: Handle out of date error
                self.cacheManager.handleRecordUploadResult(record, error: error)
            }

            recordOperation.modifyRecordsCompletionBlock = { _, deletedIds, error in
                // TODO: Handle out of date error
                guard error == nil else {
                    return
                }

                self.cacheManager.handleRecordDeletionResult(deletedIds, error: error)
            }

            self.container.privateCloudDatabase.add(recordOperation)
        }
    }
}
