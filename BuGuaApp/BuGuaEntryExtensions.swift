//
//  BuGuaEntryExtensions.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-04.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation

extension BuGuaEntryObject {
    func update(with entry: BuGuaEntry) {
        name = entry.name
        date?.update(with: entry.date)
    }
}
