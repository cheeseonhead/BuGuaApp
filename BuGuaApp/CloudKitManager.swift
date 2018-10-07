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
    var recordType: String { get }
}

extension NSManagedObject: CloudKitManagedObject {

    var recordType: String {
        fatalError("Please implement this")
    }

    func cloudKitRecord(zoneID: CKRecordZone.ID) -> CKRecord {
        return CKRecord(recordType: recordType, recordID: cloudKitRecordID(zoneID: zoneID))
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

        timer = RepeatingTimer(timeInterval: 15)
        timer.eventHandler = { [unowned self] in
            self.loop()
        }
        timer.resume()

        loop()
    }

    func loop() {
        switch state {
        case .initialized: checkLoginStatus()
        case .loggedIn: print("LoggedIn!"); return
        case .notLoggedIn, .couldNotDetermine, .restricted, .loginError: checkLoginStatus()
        case .zoneAdded: return
        }
    }

    func checkLoginStatus() {
        container.accountStatus { (status, error) in
            if let error = error {
                self.state = .loginError(error)
            } else {
                switch status {
                case .available:
                    self.state = .loggedIn
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
}
