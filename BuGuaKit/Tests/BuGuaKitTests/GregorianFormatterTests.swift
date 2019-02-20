//
//  GregorianFormatterTests.swift
//  BuGuaKitTests
//
//  Created by Jeffrey Wu on 2018-09-30.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class GregorianFormatterTests: XCTestCase {
    var sut: GregorianFormatter!
    var calendar: Calendar!

    func testGregorianZHTWMediumShort() {
        calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "zh_Hant_TW")

        sut = GregorianFormatter(calendar: calendar, dateStyle: .medium, timeStyle: .short)
        let result = sut.formatGregorianDate(.zero, time: .zero)

        XCTAssertEqual(result, "1年1月1日 上午12:00")
    }

    func testGregorianZHTWMediumMedium() {
        calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "zh_Hant_TW")

        sut = GregorianFormatter(calendar: calendar, dateStyle: .medium, timeStyle: .medium)
        let result = sut.formatGregorianDate(.zero, time: .zero)

        XCTAssertEqual(result, "1年1月1日 上午12:00:00")
    }

    func testGregorianENMediumMedium() {
        calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_us")

        sut = GregorianFormatter(calendar: calendar, dateStyle: .medium, timeStyle: .medium)
        let result = sut.formatGregorianDate(.zero, time: .zero)

        XCTAssertEqual(result, "Jan 1, 1 at 12:00:00 AM")
    }
}
