//
//  LiuYaoGuaXiangTests.swift
//  BuGuaKitTests
//
//  Created by Jeffrey Wu on 2018-08-25.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class LiuYaoGuaXiangTests: XCTestCase {
    var builder: LiuYaoGuaXiangBuilder!
    var sut: LiuYaoGuaXiang!

    override func setUp() {
        builder = LiuYaoGuaXiangBuilder(from: .default)
    }

    // MARK: - Creation

    func testCreationOne() {
        builder.setLiuYao([.youngYin, .oldYang, .youngYin, .youngYin, .youngYang, .youngYang])
        sut = builder.build()

        XCTAssertEqual(sut.originalGua.innerGua, .kan)
        XCTAssertEqual(sut.originalGua.outerGua, .xun)
        XCTAssertEqual(sut.changedGua.innerGua, .kun)
        XCTAssertEqual(sut.changedGua.outerGua, .xun)
    }

    func testCreationTwo() {
        builder.setLiuYao([.youngYang, .oldYin, .youngYin, .youngYin, .oldYang, .youngYin])
        sut = builder.build()

        XCTAssertEqual(sut.originalGua.innerGua, .zhen)
        XCTAssertEqual(sut.originalGua.outerGua, .kan)
        XCTAssertEqual(sut.changedGua.innerGua, .dui)
        XCTAssertEqual(sut.changedGua.outerGua, .kun)
    }

    // MARK: - 變爻爻支

    func testChangedDiZhiOne() {
        builder.setLiuYao([.youngYin, .oldYang, .youngYin, .youngYin, .youngYang, .youngYang])
        sut = builder.build()

        XCTAssertEqual(sut.changedDiZhi, [nil, .si, nil, nil, nil, nil])
    }

    func testChangedDiZhiTwo() {
        builder.setLiuYao([.youngYang, .oldYin, .youngYin, .youngYin, .oldYang, .youngYin])
        sut = builder.build()

        XCTAssertEqual(sut.changedDiZhi, [nil, .mao, nil, nil, .hai, nil])
    }

    // MARK: - 變六親

    func testChangedLiuQinOne() {
        builder.setLiuYao([.youngYang, .youngYang, .oldYin, .youngYin, .youngYang, .youngYang])
        sut = builder.build()

        XCTAssertEqual(sut.changedLiuQin, [nil, nil, .sibling, nil, nil, nil])
    }
}
