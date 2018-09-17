//
//  SimpleDate.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation

struct GregorianDate {
    let year: Int
    let month: Int
    let day: Int

    private let calendar = Calendar(identifier: .gregorian)

    init(timeZone: TimeZone, date: Date) {
        let dateComponents = calendar.dateComponents(in: timeZone, from: date)

        year = dateComponents.year!
        month = dateComponents.month!
        day = dateComponents.day!
    }
}
