//
//  BuGuaEntryFetcher.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation

class BuGuaEntryFetcher {

    let storageManager: StorageManager

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }

    func fetchFirst() -> BuGuaEntryMediator {
        // TODO: Use storage manager to fetch BuGuaEntryObject
        // Use that object to ask the factory to create a mediator

        return BuGuaEntryMediator(object: BuGuaEntryObject(), storageManager: self.storageManager)
    }
}
