//
//  SolarTermDateComponentTests.swift
//  BuGuaKitTests
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class SolarTermDateComponentsFetcherTests: XCTestCase {
    var sut: SolarTermDateComponentsFetcher!

    override func setUp() {
        let fakeDataLoader = MockDataLoader()
        sut = try! SolarTermDateComponentsFetcher(dataLoader: fakeDataLoader)
    }

    func testExample() {
        let components = try! sut.dateComponent(for: .chunFen, year: 2084)

        XCTAssertEqual(components.timeZone, .taipei)
        XCTAssertEqual(components.year, 2084)
        XCTAssertEqual(components.month, 3)
        XCTAssertEqual(components.day, 19)
        XCTAssertEqual(components.hour, 23)
        XCTAssertEqual(components.minute, 58)
        XCTAssertEqual(components.second, 51)
    }
}

private class MockDataLoader: SolarTermDataLoader {
    let data: [[Int]]

    override init() {
        var data = (1 ... 2400).map { _ in
            [1, 2, 3, 4, 5]
        }

        data[2021] = [2084, 3, 19, 23, 58, 51]

        self.data = data
    }

    override func loadData() throws -> [[Int]] {
        return data
    }
}
