//
//  GuaShenControllerTests.swift
//  BuGuaKitTests
//
//  Created by Cheese Onhead on 2018-10-02.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class GuaShenControllerTests: XCTestCase {
    var sut: GuaShenController!

    func testBasic() {
        let builder = LiuYaoGuaXiangBuilder(from: .default)
        builder.setLiuYao([.youngYin, .youngYin, .youngYin, .youngYang, .youngYang, .youngYang])

        sut = GuaShenController(guaXiang: builder.build())

        XCTAssertEqual(sut.guaShen, [nil, nil, nil, nil, .shen, nil])
    }

    func testBasic2() {
        let builder = LiuYaoGuaXiangBuilder(from: .default)
        builder.setLiuYao([.youngYang, .youngYin, .youngYang, .youngYang, .youngYin, .youngYang])

        sut = GuaShenController(guaXiang: builder.build())

        XCTAssertEqual(sut.guaShen, [nil, nil, nil, nil, nil, .si])
    }
}
