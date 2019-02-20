//
//  SolarTermDateComponent.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

class SolarTermDateComponentsFetcher {
    enum Error: LocalizedError {
        case yearTooOld, yearTooNew

        var errorDescription: String? {
            switch self {
            case .yearTooOld: return "年份太小"
            case .yearTooNew: return "年份太大"
            }
        }
    }

    let referenceTimeZone = TimeZone.taipei
    private let minYear = 2000
    private let maxYear = 2099
//    private let dataLoader: SolarTermDataLoader
    private let data: [[Int]]

    init(dataLoader: SolarTermDataLoader) throws {
        data = try dataLoader.loadData()
    }

    func dateComponent(for term: SolarTerm, year: Int) throws -> DateComponents {
        guard year >= 2000 else {
            throw Error.yearTooOld
        }

        guard year <= 2099 else {
            throw Error.yearTooNew
        }

        let startOfYearIndex = (year - minYear) * 24
        let termIndex = startOfYearIndex + term.index

        let dateData = data[termIndex]

        return DateComponents(timeZone: referenceTimeZone,
                              year: dateData[0],
                              month: dateData[1],
                              day: dateData[2],
                              hour: dateData[3],
                              minute: dateData[4],
                              second: dateData[5])
    }
}
