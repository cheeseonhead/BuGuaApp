//
//  Flexibility.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2019-02-26.
//  Copyright © 2019 Jeffrey Wu. All rights reserved.
//

import Foundation

struct SizeFlexibility {
    let width: Flexibility
    let height: Flexibility

    static let fixed = SizeFlexibility(width: .fixed, height: .fixed)
    static let flexible = SizeFlexibility(width: .flexible, height: .flexible)
    static let flexibleWidth = SizeFlexibility(width: .flexible, height: .fixed)
    static let flexibleHeight = SizeFlexibility(width: .fixed, height: .flexible)
}

enum Flexibility {
    case flexible
    case fixed

    init(isFlexible: Bool) {
        if isFlexible {
            self = .flexible
        } else {
            self = .fixed
        }
    }

    var isFlexible: Bool {
        switch self {
        case .flexible: return true
        case .fixed: return false
        }
    }
}
