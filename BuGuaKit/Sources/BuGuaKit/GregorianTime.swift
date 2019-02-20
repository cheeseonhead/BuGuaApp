//
//  GregorianTime.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-24.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public struct GregorianTime: Equatable {
    public static let zero = GregorianTime(hour: 0, minute: 0)

    public let hour: Int
    public let minute: Int

    private let calendar = Calendar(identifier: .gregorian)

    public init(timeZone: TimeZone, date: Date) {
        let dateComponents = calendar.dateComponents(in: timeZone, from: date)

        hour = dateComponents.hour!
        minute = dateComponents.minute!
    }

    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }

    public var components: DateComponents {
        return DateComponents(hour: hour, minute: minute, second: 0)
    }

    public var diZhi: DiZhi {
        switch hour {
        case 0: return .zi
        case 1 ... 2: return .chou
        case 3 ... 4: return .yin
        case 5 ... 6: return .mao
        case 7 ... 8: return .chen
        case 9 ... 10: return .si
        case 11 ... 12: return .wu
        case 13 ... 14: return .wei
        case 15 ... 16: return .shen
        case 17 ... 18: return .you
        case 19 ... 20: return .xu
        case 21 ... 22: return .hai
        case 23...: return .zi
        default: fatalError()
        }
    }
}
