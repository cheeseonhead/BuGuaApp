//
//  GregorianDateFormatter.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-28.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation

class GregorianDateFormatter {
    let style: DateComponentsFormatter.UnitsStyle

    init(style: DateComponentsFormatter.UnitsStyle) {
        self.style = style
    }

    func formatGregorianDate(_ date: GregorianDate, time: GregorianTime) -> String {
        var dateCompo = DateComponents(year: date.year, month: date.month, day: date.day)
        dateCompo.hour = time.hour
        dateCompo.minute = time.minute

        return DateComponentsFormatter.localizedString(from: dateCompo, unitsStyle: style)!
    }
}

extension AppFactory {
    func makeGregorianDateFormatter(style: DateComponentsFormatter.UnitsStyle) -> GregorianDateFormatter {
        return GregorianDateFormatter(style: style)
    }
}
