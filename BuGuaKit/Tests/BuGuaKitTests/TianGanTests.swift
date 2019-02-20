//
//  TianGanTests.swift
//  BuGuaKitTests
//
//  Created by Jeffrey Wu on 2018-09-15.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class TianGanTests: XCTestCase {
    func testAfterWithinBounds() {
        let sut = TianGan.bing

        XCTAssertEqual(sut.tianGan(after: 4), .geng)
    }

    func testAfterOutOfBounds() {
        let sut = TianGan.geng

        XCTAssertEqual(sut.tianGan(after: 5), .yi)
    }

    func testAfterForJia() {
        let sut = TianGan.jia

        XCTAssertEqual(sut.tianGan(after: 7210), .jia)
    }

    func testAfterNegativeWithinBounds() {
        let sut = TianGan.ji

        XCTAssertEqual(sut.tianGan(after: -3), .bing)
    }

    func testAfterNegativeOutOfBounds() {
        let sut = TianGan.ji

        XCTAssertEqual(sut.tianGan(after: -30), .ji)
    }
}
