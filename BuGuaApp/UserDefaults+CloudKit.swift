//
//  UserDefaults+CloudKit.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-13.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CloudKit
import Foundation

extension UserDefaults {
    func setToken(_ token: CKServerChangeToken?, forKey key: String) {
        guard let token = token else {
            set(nil, forKey: key)
            return
        }
        let data = try! NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
        set(data, forKey: key)
    }

    func changeToken(forKey key: String) -> CKServerChangeToken? {
        guard let data = data(forKey: key) else {
            return nil
        }

        guard let token = NSKeyedUnarchiver.unarchiveObject(with: data) as? CKServerChangeToken else {
            return nil
        }

        return token
    }
}
