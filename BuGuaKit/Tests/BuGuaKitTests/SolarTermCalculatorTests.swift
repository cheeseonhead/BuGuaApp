//
// SolarTermCalculatorTests.swift
//  BuGuaKitTests
//
//  Created by Jeffrey Wu on 2018-09-14.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

@testable import BuGuaKit
import XCTest

class SolarTermCalculatorTests: XCTestCase {
    static let componentsFetcher = try! SolarTermDateComponentsFetcher(dataLoader: MockDataLoader())

    var sut: SolarTermCalculator!

    override func setUp() {
        sut = SolarTermCalculator(dateComponentFetcher: SolarTermCalculatorTests.componentsFetcher)
    }

    func testOutOfRange() {
        XCTAssertThrowsError(try sut.termDate(for: .liChun, ofYear: 1988))
        XCTAssertThrowsError(try sut.termDate(for: .liChun, ofYear: 2109))
    }

    func testLiChun() {
        let holiday = try! sut.termDate(for: .liChun, ofYear: 2058)

        assertDate(holiday.components, month: 2, day: 3)
    }

    func testLiChun2000() {
        let holiday = try! sut.termDate(for: .liChun, ofYear: 2000)

        assertDate(holiday.components, month: 2, day: 4)
    }

    func testYuShui() {
        let holiday = try! sut.termDate(for: .yuShui, ofYear: 2008)

        assertDate(holiday.components, month: 2, day: 19)
    }

    func testJingZhe() {
        let holiday = try! sut.termDate(for: .jingZhe, ofYear: 2088)

        assertDate(holiday.components, month: 3, day: 4)
    }

    func testJingZhe2084() {
        let holiday = try! sut.termDate(for: .jingZhe, ofYear: 2084)

        assertDate(holiday.components, month: 3, day: 4)
    }

    func testChunFen() {
        let holiday = try! sut.termDate(for: .chunFen, ofYear: 2092)

        assertDate(holiday.components, month: 3, day: 19)
    }

    func testChunFen2() {
        let holiday = try! sut.termDate(for: .chunFen, ofYear: 2091)

        assertDate(holiday.components, month: 3, day: 20)
    }

    func testChunFenException() {
        let holiday = try! sut.termDate(for: .chunFen, ofYear: 2084)

        assertDate(holiday.components, month: 3, day: 19)
    }

    func testQingMing() {
        let holiday = try! sut.termDate(for: .qingMing, ofYear: 2088)

        assertDate(holiday.components, month: 4, day: 4)
    }

    func testGuYu() {
        let holiday = try! sut.termDate(for: .guYu, ofYear: 2088)

        assertDate(holiday.components, month: 4, day: 19)
    }

    func testLiXia() {
        let holiday = try! sut.termDate(for: .liXia, ofYear: 2088)

        assertDate(holiday.components, month: 5, day: 4)
    }

    func testXiaoMan() {
        let holiday = try! sut.termDate(for: .xiaoMan, ofYear: 2088)

        assertDate(holiday.components, month: 5, day: 20)
    }

    func testXiaoManException() {
        let holiday = try! sut.termDate(for: .xiaoMan, ofYear: 2008)

        assertDate(holiday.components, month: 5, day: 21)
    }

    func testMangZhong() {
        let holiday = try! sut.termDate(for: .mangZhong, ofYear: 2088)

        assertDate(holiday.components, month: 6, day: 4)
    }

    func testXiaZhi() {
        let holiday = try! sut.termDate(for: .xiaZhi, ofYear: 2088)

        assertDate(holiday.components, month: 6, day: 20)
    }

    func testXiaoShu() {
        let holiday = try! sut.termDate(for: .xiaoShu, ofYear: 2088)

        assertDate(holiday.components, month: 7, day: 6)
    }

    func testXiaoShu2016() {
        let holiday = try! sut.termDate(for: .xiaoShu, ofYear: 2016)

        assertDate(holiday.components, month: 7, day: 7)
    }

    func testDaShu() {
        let holiday = try! sut.termDate(for: .daShu, ofYear: 2088)

        assertDate(holiday.components, month: 7, day: 22)
    }

    func testLiQiu() {
        let holiday = try! sut.termDate(for: .liQiu, ofYear: 2088)

        assertDate(holiday.components, month: 8, day: 6)
    }

    func testLiQiu2002() {
        let holiday = try! sut.termDate(for: .liQiu, ofYear: 2002)

        assertDate(holiday.components, month: 8, day: 8)
    }

    func testChuShu() {
        let holiday = try! sut.termDate(for: .chuShu, ofYear: 2088)

        assertDate(holiday.components, month: 8, day: 22)
    }

    func testBaiLu() {
        let holiday = try! sut.termDate(for: .baiLu, ofYear: 2088)

        assertDate(holiday.components, month: 9, day: 6)
    }

    func testQiuFen() {
        let holiday = try! sut.termDate(for: .qiuFen, ofYear: 2088)

        assertDate(holiday.components, month: 9, day: 22)
    }

    func testHanLu() {
        let holiday = try! sut.termDate(for: .hanLu, ofYear: 2088)

        assertDate(holiday.components, month: 10, day: 7)
    }

    func testShuangJiang() {
        let holiday = try! sut.termDate(for: .shuangJiang, ofYear: 2088)

        assertDate(holiday.components, month: 10, day: 22)
    }

    func testShuangJiang2089() {
        let holiday = try! sut.termDate(for: .shuangJiang, ofYear: 2089)

        assertDate(holiday.components, month: 10, day: 23)
    }

    func testLiDong() {
        let holiday = try! sut.termDate(for: .liDong, ofYear: 2088)

        assertDate(holiday.components, month: 11, day: 6)
    }

    func testXiaoXue() {
        let holiday = try! sut.termDate(for: .xiaoXue, ofYear: 2088)

        assertDate(holiday.components, month: 11, day: 21)
    }

    func testDaXue() {
        let holiday = try! sut.termDate(for: .daXue, ofYear: 2088)

        assertDate(holiday.components, month: 12, day: 6)
    }

    func testDongZhi() {
        let holiday = try! sut.termDate(for: .dongZhi, ofYear: 2088)

        assertDate(holiday.components, month: 12, day: 21)
    }

    func testDongZhi2021() {
        let holiday = try! sut.termDate(for: .dongZhi, ofYear: 2021)

        assertDate(holiday.components, month: 12, day: 21)
    }

    func testXiaoHan() {
        let holiday = try! sut.termDate(for: .xiaoHan, ofYear: 2088)

        assertDate(holiday.components, month: 1, day: 5)
    }

    func testXiaoHan2019() {
        let holiday = try! sut.termDate(for: .xiaoHan, ofYear: 2019)

        assertDate(holiday.components, month: 1, day: 5)
    }

    func testDaHan() {
        let holiday = try! sut.termDate(for: .daHan, ofYear: 2089)

        assertDate(holiday.components, month: 1, day: 19)
    }

    func testDaHan2082() {
        let holiday = try! sut.termDate(for: .daHan, ofYear: 2082)

        assertDate(holiday.components, month: 1, day: 20)
    }

    func assertDate(_ dateCompo: GregorianDate, month: Int, day: Int) {
        XCTAssertEqual(dateCompo.month, month)
        XCTAssertEqual(dateCompo.day, day)
    }
}

// MARK: - Date Gan Zhi

extension SolarTermCalculatorTests {
    func testGanZhiMinimum() {
        let ganZhi = try! sut.ganZhi(for: .init(year: 2001, month: 1, day: 1))

        assertGanZhi(ganZhi.year, .geng, .chen)
        assertGanZhi(ganZhi.month, .wu, .zi)
        assertGanZhi(ganZhi.day, .jia, .zi)
    }

    func testGanZhiMaximum() {
        let ganZhi = try! sut.ganZhi(for: .init(year: 2099, month: 12, day: 31))

        assertGanZhi(ganZhi.year, .ji, .wei)
        assertGanZhi(ganZhi.month, .bing, .zi)
        assertGanZhi(ganZhi.day, .ren, .yin)
    }

    func assertGanZhi(_ ganZhi: GanZhi, _ gan: TianGan, _ zhi: DiZhi, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(ganZhi.tianGan, gan, file: file, line: line)
        XCTAssertEqual(ganZhi.diZhi, zhi, file: file, line: line)
    }
}

// MARK: - Day Gan Zhi for Date

extension SolarTermCalculatorTests {
    func testDayGanZhi20991231() {
        let result = sut.dayGanZhi(for: GregorianDate(year: 2099, month: 12, day: 31))

        XCTAssertEqual(result.tianGan, .ren)
        XCTAssertEqual(result.diZhi, .yin)
    }

    func testDayGanZhi20000101() {
        let result = sut.dayGanZhi(for: GregorianDate(year: 2000, month: 1, day: 1))

        XCTAssertEqual(result.tianGan, .wu)
        XCTAssertEqual(result.diZhi, .wu)
    }

    func testDayGanZhi24980416() {
        let result = sut.dayGanZhi(for: GregorianDate(year: 2498, month: 4, day: 16))

        XCTAssertEqual(result.tianGan, .yi)
        XCTAssertEqual(result.diZhi, .hai)
    }
}

// MARK: - Year Gan Zhi for Date

extension SolarTermCalculatorTests {
    func testYearGanZhi20000101() {
        XCTAssertThrowsError(try sut.yearGanZhi(for: GregorianDate(year: 2000, month: 1, day: 1)))
    }

    func testYearGanZhi21000604() {
        XCTAssertThrowsError(try sut.yearGanZhi(for: GregorianDate(year: 2100, month: 6, day: 4)))
    }

    func testYearGanZhi20010101() {
        let ganZhi = try! sut.yearGanZhi(for: GregorianDate(year: 2001, month: 01, day: 1))

        XCTAssertEqual(ganZhi.tianGan, .geng)
        XCTAssertEqual(ganZhi.diZhi, .chen)
    }

    func testYearGanZhi20010204() {
        let ganZhi = try! sut.yearGanZhi(for: GregorianDate(year: 2001, month: 2, day: 4))

        XCTAssertEqual(ganZhi.tianGan, .xin)
        XCTAssertEqual(ganZhi.diZhi, .si)
    }

    func testYearGanZhi20230205() {
        let ganZhi = try! sut.yearGanZhi(for: GregorianDate(year: 2023, month: 2, day: 5))

        XCTAssertEqual(ganZhi.tianGan, .gui)
        XCTAssertEqual(ganZhi.diZhi, .mao)
    }

    func testYearGanZhi20280204() {
        let ganZhi = try! sut.yearGanZhi(for: GregorianDate(year: 2028, month: 2, day: 4))

        XCTAssertEqual(ganZhi.tianGan, .wu)
        XCTAssertEqual(ganZhi.diZhi, .shen)
    }

    func testYearGanZhi20260908() {
        let ganZhi = try! sut.yearGanZhi(for: GregorianDate(year: 2026, month: 9, day: 8))

        XCTAssertEqual(ganZhi.tianGan, .bing)
        XCTAssertEqual(ganZhi.diZhi, .wu)
    }
}

// MARK: - Month Gan Zhi for Date

extension SolarTermCalculatorTests {
    func testGanZhi20840319Toronto() {
        let components = GregorianDate(year: 2084, month: 3, day: 19)

        let result = try! sut.monthGanZhi(for: components)
        result.tianGan.equal(.ding)
        result.diZhi.equal(.mao)
    }

    func testGanZhi20840318Toronto() {
        let components = GregorianDate(year: 2084, month: 3, day: 18)

        let result = try! sut.monthGanZhi(for: components)
        result.tianGan.equal(.ding)
        result.diZhi.equal(.mao)
    }

    func testGanZhi20840304Toronto() {
        let components = GregorianDate(year: 2084, month: 3, day: 4)

        let result = try! sut.monthGanZhi(for: components)
        result.tianGan.equal(.ding)
        result.diZhi.equal(.mao)
    }

    func testGanZhi20840303Toronto() {
        let components = GregorianDate(year: 2084, month: 3, day: 3)

        let result = try! sut.monthGanZhi(for: components)
        result.tianGan.equal(.bing)
        result.diZhi.equal(.yin)
    }
}

// MARK: - Getting the right month term

extension SolarTermCalculatorTests {
    func testCanadaTime20840319Night() {
        let dateComponents = GregorianDate(year: 2084, month: 3, day: 19)

        let holiday = try! sut.sameMonthGanZhiTerm(for: dateComponents)

        XCTAssertEqual(holiday.type, .chunFen)
    }

    func testCanadaTime20840319Noon() {
        let dateComponents = GregorianDate(year: 2084, month: 3, day: 19)

        let holiday = try! sut.sameMonthGanZhiTerm(for: dateComponents)

        XCTAssertEqual(holiday.components, GregorianDate(year: 2084, month: 3, day: 19))
        XCTAssertEqual(holiday.type, .chunFen)
    }

    func testCanadaTime20840319Morning() {
        let dateComponents = GregorianDate(year: 2084, month: 3, day: 19)

        let holiday = try! sut.sameMonthGanZhiTerm(for: dateComponents)

        XCTAssertEqual(holiday.type, .chunFen)
    }

    func testSameHoliday20000101() {
        let dateComponents = GregorianDate(year: 2000, month: 1, day: 1)

        XCTAssertThrowsError(try sut.sameMonthGanZhiTerm(for: dateComponents))
    }

    func testSameHoliday20991231() {
        let dateComponents = GregorianDate(year: 2099, month: 12, day: 31)

        XCTAssertEqual(try! sut.sameMonthGanZhiTerm(for: dateComponents).type, .dongZhi)
    }
}

// MARK: - Xiao Han Month Tian Gan

extension SolarTermCalculatorTests {
    func testTianGanXiaoHan2000() {
        let tianGan = sut.xiaoHanMonthTianGan(forYear: 2000)

        tianGan.equal(.ding)
    }

    func testTianGanXiaoHan2084() {
        sut.xiaoHanMonthTianGan(forYear: 2084).equal(.yi)
    }

    func testTianGanXiaoHan1985() {
        sut.xiaoHanMonthTianGan(forYear: 1985).equal(.ding)
    }
}

// MARK: - Month Gan Zhi For Term Date

extension SolarTermCalculatorTests {
    func testGanZhi2084ChunFenAsia() {
        let components = GregorianDate(year: 2084, month: 3, day: 20)

        let result = sut.monthGanZhi(for: SolarTerm.Date(components: components, type: .chunFen))
        result.tianGan.equal(.ding)
        result.diZhi.equal(.mao)
    }

    func testGanZhi2084ChunFenToronto() {
        let components = GregorianDate(year: 2084, month: 3, day: 19)

        let result = sut.monthGanZhi(for: SolarTerm.Date(components: components, type: .chunFen))
        result.tianGan.equal(.ding)
        result.diZhi.equal(.mao)
    }

    func testGanZhi2084MangZhongAsia() {
        let components = GregorianDate(year: 2084, month: 6, day: 5)

        let result = sut.monthGanZhi(for: SolarTerm.Date(components: components, type: .mangZhong))
        result.tianGan.equal(.geng)
        result.diZhi.equal(.wu)
    }
}

private extension TianGan {
    func equal(_ other: TianGan, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self, other, file: file, line: line)
    }
}

private extension DiZhi {
    func equal(_ other: DiZhi, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self, other, file: file, line: line)
    }
}

private class MockDataLoader: SolarTermDataLoader {
    var data: [[Int]]!

    override init() {
        super.init()
        data = try! super.loadData()
    }

    override func loadData() throws -> [[Int]] {
        return data
    }
}
