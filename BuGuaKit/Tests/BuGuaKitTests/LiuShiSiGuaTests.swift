//
//  LiuShiSiGuaTests.swift
//  BuGuaKitTests
//
//  Created by Cheese Onhead on 2018-07-22.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class LiuShiSiGuaTests: XCTestCase {
    var sut: LiuShiSiGua!

    // MARK: - 世應

    func testShiYingForAllSame() {
        sut = LiuShiSiGua(innerGua: .li, outerGua: .li)

        XCTAssertEqual(sut.shi, 6)
        XCTAssertEqual(sut.ying, 3)
    }

    func testShiYingForBottomDifferent() {
        sut = LiuShiSiGua(innerGua: .qian, outerGua: .xun)

        XCTAssertEqual(sut.shi, 1)
        XCTAssertEqual(sut.ying, 4)
    }

    func testShiYingForTopSame() {
        sut = LiuShiSiGua(innerGua: .li, outerGua: .xun)

        XCTAssertEqual(sut.shi, 2)
        XCTAssertEqual(sut.ying, 5)
    }

    func testShiYingForAllDifferent() {
        sut = LiuShiSiGua(innerGua: .qian, outerGua: .kun)

        XCTAssertEqual(sut.shi, 3)
        XCTAssertEqual(sut.ying, 6)
    }

    func testShiYingForBottomSame() {
        sut = LiuShiSiGua(innerGua: .qian, outerGua: .zhen)

        XCTAssertEqual(sut.shi, 4)
        XCTAssertEqual(sut.ying, 1)
    }

    func testShiYingTopDifferent() {
        sut = LiuShiSiGua(innerGua: .kan, outerGua: .xun)

        XCTAssertEqual(sut.shi, 5)
        XCTAssertEqual(sut.ying, 2)
    }

    func testShiYingMiddleSame() {
        sut = LiuShiSiGua(innerGua: .li, outerGua: .kun)

        XCTAssertEqual(sut.shi, 4)
        XCTAssertEqual(sut.ying, 1)
    }

    func testShiYingMiddleDifferent() {
        sut = LiuShiSiGua(innerGua: .zhen, outerGua: .dui)

        XCTAssertEqual(sut.shi, 3)
        XCTAssertEqual(sut.ying, 6)
    }

    // MARK: - 卦宮

    func testGuaGongShiAtOne() {
        sut = LiuShiSiGua(innerGua: .qian, outerGua: .xun)

        XCTAssertEqual(sut.guaGong, .xun)
    }

    func testGuaGongShiAtTwo() {
        sut = LiuShiSiGua(innerGua: .li, outerGua: .xun)

        XCTAssertEqual(sut.guaGong, .xun)
    }

    func testGuaGongAllDifferent() {
        sut = LiuShiSiGua(innerGua: .qian, outerGua: .kun)

        XCTAssertEqual(sut.guaGong, .kun)
    }

    func testGuaGongMiddleDifferent() {
        sut = LiuShiSiGua(innerGua: .zhen, outerGua: .dui)

        XCTAssertEqual(sut.guaGong, .zhen)
    }

    func testGuaGongShiAtFour() {
        sut = LiuShiSiGua(innerGua: .li, outerGua: .kun)

        XCTAssertEqual(sut.guaGong, FuXiBaGua.li.opposite)
    }

    func testGuaGongShiAtFive() {
        sut = LiuShiSiGua(innerGua: .kan, outerGua: .xun)

        XCTAssertEqual(sut.guaGong, FuXiBaGua.kan.opposite)
    }

    func testGuaGongShiAtSix() {
        sut = LiuShiSiGua(innerGua: .li, outerGua: .li)

        XCTAssertEqual(sut.guaGong, .li)
    }

    // MARK: - 爻支

    func testBasicDiZhi() {
        sut = LiuShiSiGua(innerGua: .kun, outerGua: .kan)

        XCTAssertEqual(sut.diZhi, [.wei, .si, .mao, .shen, .xu, .zi])
    }

    func testBasicDiZhiTwo() {
        sut = LiuShiSiGua(innerGua: .zhen, outerGua: .kan)

        XCTAssertEqual(sut.diZhi, [.zi, .yin, .chen, .shen, .xu, .zi])
    }

    // MARK: - 六親之我

    func testMyXing() {
        sut = LiuShiSiGua(innerGua: .zhen, outerGua: .kan)

        XCTAssertEqual(sut.myXing, .water)
    }

    // MARK: - 六親

    func testLiuQin() {
        sut = LiuShiSiGua(innerGua: .li, outerGua: .qian)

        XCTAssertEqual(sut.liuQin, [.parent, .descendant, .superior, .sibling, .wealth, .descendant])
    }

    // MARK: - Character Test

    func testCharacter() {
        sut = LiuShiSiGua(innerGua: .dui, outerGua: .gen)

        XCTAssertEqual(sut.character, "山澤損")
    }
}
