//
//  GregorianFormatter.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-30.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public struct GregorianFormatter {
    private let calendar: Calendar
    private let formatter: DateFormatter

    /// Pass in the calendar that it should be using to format the Gregorian Date and Time. This formatter will respect
    /// the locale set on the calendar object.
    public init(calendar: Calendar, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
        self.calendar = calendar

        formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = calendar.locale
    }

    public func formatGregorianDate(_ date: GregorianDate, time: GregorianTime) -> String {
        var dateCompo = date.components
        let timeCompo = time.components
        dateCompo.hour = timeCompo.hour
        dateCompo.minute = timeCompo.minute
        dateCompo.second = timeCompo.second

        let date = calendar.date(from: dateCompo)!

        return formatter.string(from: date)
    }
}
