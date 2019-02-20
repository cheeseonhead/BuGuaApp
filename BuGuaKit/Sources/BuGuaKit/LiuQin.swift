//
//  LiuQin.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-08-27.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public enum LiuQin {
    case parent, descendant, wealth, sibling, superior

    init(from relationship: WuXing.Relationship) {
        switch relationship {
        case .generatedBy: self = .parent
        case .generates: self = .descendant
        case .overcomes: self = .wealth
        case .same: self = .sibling
        case .overcomedBy: self = .superior
        }
    }

    public var character: String {
        return NSLocalizedString("liuqin\(self)", tableName: nil, bundle: Bundle(identifier: "com.cheeseonhead.BuGuaKit")!, value: "", comment: "")
    }
}
