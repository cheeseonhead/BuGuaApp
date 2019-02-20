//
//  WuXing.swift
//  BuGuaKit
//
//  Created by Cheese Onhead on 2018-07-22.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public enum WuXing: CaseIterable {
    public enum Relationship {
        case generates, generatedBy, same, overcomes, overcomedBy
    }

    case gold, wood, water, fire, earth

    public var character: String {
        return NSLocalizedString("wuxing\(self)", tableName: nil, bundle: Bundle(identifier: "com.cheeseonhead.BuGuaKit")!, value: "", comment: "")
    }

    public var generates: WuXing {
        switch self {
        case .gold: return .water
        case .water: return .wood
        case .wood: return .fire
        case .fire: return .earth
        case .earth: return .gold
        }
    }

    public var generatedBy: WuXing {
        return WuXing.allCases.first(where: { $0.generates == self })!
    }

    public var overcomes: WuXing {
        switch self {
        case .gold: return .wood
        case .wood: return .earth
        case .earth: return .water
        case .water: return .fire
        case .fire: return .gold
        }
    }

    public var overcomedBy: WuXing {
        return WuXing.allCases.first(where: { $0.overcomes == self })!
    }

    public func relationShip(to wuXing: WuXing) -> Relationship {
        if generates == wuXing {
            return .generates
        } else if generatedBy == wuXing {
            return .generatedBy
        } else if wuXing == self {
            return .same
        } else if overcomes == wuXing {
            return .overcomes
        } else if overcomedBy == wuXing {
            return .overcomedBy
        }

        fatalError("\(self) and \(wuXing) don't have a defined relationship.")
    }
}
