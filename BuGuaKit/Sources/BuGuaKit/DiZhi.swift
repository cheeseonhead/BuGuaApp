//
//  DiZhi.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-08-25.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public enum DiZhi: CaseIterable {
    case zi, chou, yin, mao, chen, si, wu, wei, shen, you, xu, hai

    public var character: String {
        return NSLocalizedString("dizhi\(self)", tableName: nil, bundle: Bundle(identifier: "com.cheeseonhead.BuGuaKit")!, value: "", comment: "")
    }

    public var wuXing: WuXing {
        switch self {
        case .chou, .chen, .wei, .xu: return .earth
        case .hai, .zi: return .water
        case .yin, .mao: return .wood
        case .si, .wu: return .fire
        case .shen, .you: return .gold
        }
    }

    func diZhi(after count: Int) -> DiZhi {
        let totalCount = DiZhi.allCases.count

        let selfIndex = index()
        let remainder = (selfIndex + count) % totalCount

        let positiveRemainder = (totalCount + remainder) % totalCount

        return DiZhi.allCases[positiveRemainder]
    }
}

private extension DiZhi {
    func index() -> Int {
        return DiZhi.allCases.firstIndex(of: self)!
    }
}
