//
//  GregorianDateExtensions.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-10-04.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation

extension GregorianDateObject {
    func update(with gregorianDate: GregorianDate) {
        year = Int64(gregorianDate.year)
        month = Int64(gregorianDate.month)
        day = Int64(gregorianDate.day)
    }
}
