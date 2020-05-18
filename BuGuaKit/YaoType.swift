//
//  YaoType.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-08-25.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public enum YaoType: CaseIterable, Equatable {
    case oldYang, oldYin, youngYang, youngYin

    public var originalYi: LiangYi {
        switch self {
        case .oldYang, .youngYang: return .yang
        case .oldYin, .youngYin: return .yin
        }
    }

    public var changedYi: LiangYi {
        switch self {
        case .oldYin, .youngYang: return .yang
        case .oldYang, .youngYin: return .yin
        }
    }

    public var toggledStability: YaoType {
        switch self {
        case .oldYang: return .youngYang
        case .oldYin: return .youngYin
        case .youngYang: return .oldYang
        case .youngYin: return .oldYin
        }
    }

    public var isStable: Bool {
        switch self {
        case .oldYin, .oldYang: return false
        case .youngYin, .youngYang: return true
        }
    }
}
