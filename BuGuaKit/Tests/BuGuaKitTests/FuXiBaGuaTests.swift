//
//  FuXiBaGuaTests.swift
//  BuGuaKitTests
//
//  Created by Cheese Onhead on 2018-07-22.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class FuXiBaGuaTests: XCTestCase {
    var sut: FuXiBaGua!

    func testCharacter() {
        sut = .li

        XCTAssertEqual("離", sut.character)
    }

    // MARK: - Creation

    func testCreateKanFromLiangYi() {
        sut = FuXiBaGua(top: .yin, middle: .yang, bottom: .yin)

        XCTAssertEqual(sut, .kan)
    }

    func testCreateZhenFromLiangYi() {
        sut = FuXiBaGua(top: .yin, middle: .yin, bottom: .yang)

        XCTAssertEqual(sut, .zhen)
    }
}
