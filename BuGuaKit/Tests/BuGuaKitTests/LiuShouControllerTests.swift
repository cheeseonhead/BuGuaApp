//
//  LiuShouControllerTests.swift
//  BuGuaKitTests
//
//  Created by Cheese Onhead on 2018-10-02.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class LiuShouControllerTests: XCTestCase {
    var sut: LiuShouController!

    func testBasic() {
        let builder = LiuYaoGuaXiangBuilder(from: .default)
        builder.setDateGanZhi(DateGanZhi(year: GanZhi(.ding, .hai), month: GanZhi(.gui, .chou), day: GanZhi(.gui, .you)))

        sut = LiuShouController(guaXiang: builder.build())

        XCTAssertEqual(sut.liuShou, [.tortoise, .dragon, .bird, .hook, .snake, .tiger])
    }

    func testBasic2() {
        let builder = LiuYaoGuaXiangBuilder(from: .default)
        builder.setDateGanZhi(DateGanZhi(year: GanZhi(.wu, .zi), month: GanZhi(.xin, .you), day: GanZhi(.ji, .si)))

        sut = LiuShouController(guaXiang: builder.build())

        XCTAssertEqual(sut.liuShou, [.snake, .tiger, .tortoise, .dragon, .bird, .hook])
    }
}
