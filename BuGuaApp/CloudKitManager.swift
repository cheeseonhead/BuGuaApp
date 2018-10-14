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

    // MARK: - PriConstants

    private let updateInterval = TimeInterval(10)
    private let serverChangeTokenKey = "serverChangeToken"
    private let customZoneTokenKey = "TestZoneChangeToken"

    // MARK: - Private

    private let timer: RepeatingTimer

    init(container: CKContainer, zone: CKRecordZone, cacheManager: CacheManager, updateManager: UpdateManager) {
        self.container = container
        self.zone = zone
        self.cacheManager = cacheManager
        self.updateManager = updateManager

        timer = RepeatingTimer(timeInterval: updateInterval)
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
                    self.loop()
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
                self.loop()
            }
        }

        zoneOperation.start()
    }

    func fetchUpdates() {
        // TODO: Make UserDefaults injected
        var latestServerChangeToken = UserDefaults.standard.changeToken(forKey: serverChangeTokenKey)

        let zoneChangesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: latestServerChangeToken)

        var changedZoneIDs: [CKRecordZone.ID] = []

        zoneChangesOperation.recordZoneWithIDChangedBlock = { zoneID in
            print("Zone has changed: \(zoneID)")
            changedZoneIDs.append(zoneID)
        }

        zoneChangesOperation.changeTokenUpdatedBlock = { serverChangeToken in
            print("New server token:\(serverChangeToken)")
            latestServerChangeToken = serverChangeToken
        }

        zoneChangesOperation.fetchDatabaseChangesCompletionBlock = { token, _, error in
            // TODO: Handle Error
            guard error == nil else {
                print("Error Occured: \(error!.localizedDescription)")
                return
            }

            print("Final new server token:\(token!)")
            latestServerChangeToken = token

            self.fetchZoneChanges(zoneIDs: changedZoneIDs) {
                UserDefaults.standard.setToken(latestServerChangeToken, forKey: self.serverChangeTokenKey)
                self.updateManager.flushChanges()
                // TODO: Change this to inSync
                self.state = .serverOutdated
            }
        }

        container.privateCloudDatabase.add(zoneChangesOperation)
    }

    func fetchZoneChanges(zoneIDs: [CKRecordZone.ID], completion: @escaping () -> Void) {
        guard zoneIDs.count > 0 else {
            completion()
            return
        }

        // Look up the previous change token for each zone
        var optionsByRecordZoneID = [CKRecordZone.ID: CKFetchRecordZoneChangesOperation.ZoneOptions]()

        for zoneID in zoneIDs {
            let options = CKFetchRecordZoneChangesOperation.ZoneOptions()
            options.previousServerChangeToken = UserDefaults.standard.changeToken(forKey: customZoneTokenKey)
            optionsByRecordZoneID[zoneID] = options
        }

        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: zoneIDs, optionsByRecordZoneID: optionsByRecordZoneID)

        operation.recordChangedBlock = { record in
            print("Record updated: \(record)")
            self.updateManager.recordChanged(record)
        }

        operation.recordWithIDWasDeletedBlock = { recordId, _ in
            print("Record deleted: \(recordId)")
            self.updateManager.recordDeleted(recordId)
        }

        operation.recordZoneFetchCompletionBlock = { zoneId, changeToken, _, _, error in
            // TODO: Handle Error
            guard error == nil else {
                print("Error Occured: \(error!.localizedDescription)")
                return
            }

            print("zoneFetch Completed! Zone: \(zoneId) Token:\(changeToken!)")
            UserDefaults.standard.setToken(changeToken, forKey: self.customZoneTokenKey)
        }

        operation.fetchRecordZoneChangesCompletionBlock = { error in
            // TODO: Handle Error
            guard error == nil else {
                print("Error Occured: \(error!.localizedDescription)")
                return
            }

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
                    self.updateManager.recordChanged(record)
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
