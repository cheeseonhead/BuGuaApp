//
//  KongWangControllerTests.swift
//  BuGuaKitTests
//
//  Created by Jeffrey Wu on 2018-10-01.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class KongWangControllerTests: XCTestCase {
    var sut: KongWangController!

    func testBasicKongWang() {
        let builder = LiuYaoGuaXiangBuilder(from: .default)
        let dateGanZhi = DateGanZhi(year: GanZhi(.wu, .chen), month: GanZhi(.ding, .si), day: GanZhi(.gui, .wei))

        builder.setDateGanZhi(dateGanZhi)
        builder.setTimeDiZhi(.shen)

        sut = KongWangController(guaXiang: builder.build())

        XCTAssertEqual(sut.kongWang, KongWang(diZhis: [.shen, .you]))
    }

    func testBasicKongWang2() {
        let builder = LiuYaoGuaXiangBuilder(from: .default)
        let dateGanZhi = DateGanZhi(year: GanZhi(.jia, .zi), month: GanZhi(.jia, .xu), day: GanZhi(.ding, .chou))

        builder.setDateGanZhi(dateGanZhi)
        builder.setTimeDiZhi(.you)

        sut = KongWangController(guaXiang: builder.build())

        XCTAssertEqual(sut.kongWang, KongWang(diZhis: [.shen, .you]))
    }
}
