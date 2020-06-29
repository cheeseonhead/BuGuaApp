//
//  TianGan.swift
//  BuGuaKit
//
//  Created by Cheese Onhead on 2018-09-11.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public enum TianGan: CaseIterable {
    case jia, yi, bing, ding, wu, ji, geng, xin, ren, gui

    public var character: String {
        return NSLocalizedString("tiangan\(self)", tableName: nil, bundle: Bundle.module, value: "", comment: "")
    }

    func tianGan(after count: Int) -> TianGan {
        let totalCount = TianGan.allCases.count

        let selfIndex = index()
        let remainder = (selfIndex + count) % totalCount

        let positiveRemainder = (totalCount + remainder) % totalCount

        return TianGan.allCases[positiveRemainder]
    }

    func distanceTo(_ other: TianGan) -> Int {
        return other.index() - index()
    }
}

private extension TianGan {
    func index() -> Int {
        return TianGan.allCases.firstIndex(of: self)!
    }
}
