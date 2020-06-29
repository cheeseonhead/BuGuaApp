//
//  LiangYi.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-08-25.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public enum LiangYi {
    case yang, yin

    public var yaoType: YaoType {
        switch self {
        case .yang: return .youngYang
        case .yin: return .youngYin
        }
    }
}
