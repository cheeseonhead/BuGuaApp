//
//  GregorianDate.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public struct GregorianDate: Comparable, Equatable {
    public static let zero = GregorianDate(year: 1, month: 1, day: 1)

    public let year: Int
    public let month: Int
    public let day: Int

    private let calendar = Calendar(identifier: .gregorian)

    public init(timeZone: TimeZone, date: Date) {
        let dateComponents = calendar.dateComponents(in: timeZone, from: date)

        year = dateComponents.year!
        month = dateComponents.month!
        day = dateComponents.day!
    }

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    public var components: DateComponents {
        return DateComponents(year: year, month: month, day: day)
    }

    public static func < (lhs: GregorianDate, rhs: GregorianDate) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else if lhs.day != rhs.day {
            return lhs.day < rhs.day
        }

        return false
    }

    func days(from otherComponents: GregorianDate) -> Int {
        let selfCompo = components
        let otherCompo = otherComponents.components

        let days = Calendar.current.dateComponents([.day], from: otherCompo, to: selfCompo).day!

        return days
    }
}
