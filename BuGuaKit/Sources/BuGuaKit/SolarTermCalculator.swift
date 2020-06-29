//
//  SolarTermCalculator.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-14.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public class SolarTermCalculator {
    enum Error: LocalizedError {
        case yearOutOfRange(year: Int, Int, Int)

        var errorDescription: String? {
            switch self {
            case let .yearOutOfRange(year, minYear, maxYear): return "\(year)不在\(minYear)到\(maxYear)之間"
            }
        }
    }

    // MARK: - Private Constant

    private let minYear = 2000
    private let maxYear = 2099

    // MARK: - Private Properties

    private let componentFetcher: SolarTermDateComponentsFetcher

    public static func make() throws -> SolarTermCalculator {
        return SolarTermCalculator(dateComponentFetcher: try SolarTermDateComponentsFetcher(dataLoader: SolarTermDataLoader()))
    }

    init(dateComponentFetcher: SolarTermDateComponentsFetcher) {
        componentFetcher = dateComponentFetcher
    }

    public func ganZhi(for dateComponents: GregorianDate) throws -> DateGanZhi {
        let year = try yearGanZhi(for: dateComponents)
        let month = try monthGanZhi(for: dateComponents)
        let day = dayGanZhi(for: dateComponents)

        return DateGanZhi(year: year, month: month, day: day)
    }

    func termDate(for term: SolarTerm, ofYear year: Int) throws -> SolarTerm.Date {
        let dateComponents = try componentFetcher.dateComponent(for: term, year: year)

        let termComponents = GregorianDate(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)

        return SolarTerm.Date(components: termComponents, type: term)
    }
}

// MARK: - Day Gan Zhi

extension SolarTermCalculator {
    private var referenceDateGanZhi: GanZhi { return GanZhi(.wu, .wu) }
    private var referenceDateComponents: GregorianDate { return GregorianDate(year: 2000, month: 1, day: 1) }

    func dayGanZhi(for dateComponents: GregorianDate) -> GanZhi {
        let daysPassed = dateComponents.days(from: referenceDateComponents)

        let tianGan = referenceDateGanZhi.tianGan.tianGan(after: daysPassed)
        let diZhi = referenceDateGanZhi.diZhi.diZhi(after: daysPassed)

        return GanZhi(tianGan, diZhi)
    }
}

// MARK: - Year Gan Zhi

extension SolarTermCalculator {
    private var liChun2000YearGanZhi: GanZhi { return GanZhi(.geng, .chen) }
    private var liChunReferenceYear: Int { return 2000 }

    func yearGanZhi(for dateComponents: GregorianDate) throws -> GanZhi {
        let possibleLiChuns = [
            try termDate(for: .liChun, ofYear: dateComponents.year - 1),
            try termDate(for: .liChun, ofYear: dateComponents.year),
        ]

        let sameYearLiChun = possibleLiChuns[1].components <= dateComponents ? possibleLiChuns[1] : possibleLiChuns[0]

        return liChunYearGanZhi(forYear: sameYearLiChun.components.year)
    }

    func liChunYearGanZhi(forYear year: Int) -> GanZhi {
        let yearsPassed = year - liChunReferenceYear

        let tianGan = liChun2000YearGanZhi.tianGan.tianGan(after: yearsPassed)
        let diZhi = liChun2000YearGanZhi.diZhi.diZhi(after: yearsPassed)

        return GanZhi(tianGan, diZhi)
    }
}

// MARK: - Month Gan Zhi

extension SolarTermCalculator {
    private var xiaoHan2000TianGan: TianGan { return .ding }
    private var xiaoHanReferenceYear: Int { return 2000 }

    func monthGanZhi(for dateComponents: GregorianDate) throws -> GanZhi {
        let term = try sameMonthGanZhiTerm(for: dateComponents)
        let ganZhiForTerm = monthGanZhi(for: term)

        return ganZhiForTerm
    }

    func sameMonthGanZhiTerm(for dateComponents: GregorianDate) throws -> SolarTerm.Date {
        let year = dateComponents.year

        let possibleTermDates = try terms(forYears: [year - 1, year]).sorted(by: { $0.components < $1.components })

        var finalTermDate: SolarTerm.Date!
        for termDate in possibleTermDates {
            guard termDate.components <= dateComponents else { break }

            finalTermDate = termDate
        }

        return finalTermDate
    }

    func monthGanZhi(for termDate: SolarTerm.Date) -> GanZhi {
        let tianGan = monthTianGan(for: termDate)
        let diZhi = SolarTermCalculator.diZhi(for: termDate)

        return GanZhi(tianGan, diZhi)
    }

    func monthTianGan(for termDate: SolarTerm.Date) -> TianGan {
        let monthOffsetFromXiaoHan = termDate.type.index / 2
        return xiaoHanMonthTianGan(forYear: termDate.components.year)
            .tianGan(after: monthOffsetFromXiaoHan)
    }

    func xiaoHanMonthTianGan(forYear year: Int) -> TianGan {
        let monthsPassed = (year - xiaoHanReferenceYear) * 12
        let tianGanThisYear = xiaoHan2000TianGan.tianGan(after: monthsPassed)

        return tianGanThisYear
    }
}

// MARK: - Gan Zhi Helpers

private extension SolarTermCalculator {
    static func diZhi(for term: SolarTerm.Date) -> DiZhi {
        switch term.components.month {
        case 1: return .chou
        case 2: return .yin
        case 3: return .mao
        case 4: return .chen
        case 5: return .si
        case 6: return .wu
        case 7: return .wei
        case 8: return .shen
        case 9: return .you
        case 10: return .xu
        case 11: return .hai
        case 12: return .zi
        default: fatalError()
        }
    }
}

// MARK: - Term Date

private extension SolarTermCalculator {
    func terms(forYears years: [Int]) throws -> [SolarTerm.Date] {
        return try years.flatMap {
            try terms(forYear: $0)
        }
    }

    func terms(forYear year: Int) throws -> [SolarTerm.Date] {
        return try SolarTerm.allCases.map {
            try termDate(for: $0, ofYear: year)
        }
    }
}
