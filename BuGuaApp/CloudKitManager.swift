//
//  CloudKitManager.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-04.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import CloudKit
import Foundation

class CloudKitManager {

    let container: CKContainer

    init(container: CKContainer) {
        self.container = container
    }
}
