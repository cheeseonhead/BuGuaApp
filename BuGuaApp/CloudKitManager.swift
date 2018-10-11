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

        case zoneAdded
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
            recordOperation.perRecordCompletionBlock = { record, error in
                print(error?.localizedDescription ?? "")
                print(record)
            }
            recordOperation.modifyRecordsCompletionBlock = { modifiedRecords, deletedIds, error in
                // TODO: Handle error
                guard error == nil else {
                    return
                }

                // TODO: Handle Deletion
                self.cacheManager.handleCacheUpdates(ckRecords: modifiedRecords ?? [], deletedIds: deletedIds ?? [])
            }

            self.container.privateCloudDatabase.add(recordOperation)
        }
    }
}
