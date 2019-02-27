//
//  Dimension.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2019-02-26.
//  Copyright © 2019 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

struct Dimension {
    let width: Length
    let height: Length

    struct Adjustment {
        let width: Length.Adjustment
        let height: Length.Adjustment

        init(width: Length.Adjustment, height: Length.Adjustment) {
            self.width = width
            self.height = height
        }

        init(available: CGSize) {
            width = .available(available.width)
            height = .available(available.height)
        }
    }

    init(_ width: Length, _ height: Length) {
        self.width = width
        self.height = height
    }

    init(_ minSize: CGSize, _ flexibility: SizeFlexibility) {
        self.init(Length(flexibility.width, minSize.width), Length(flexibility.height, minSize.height))
    }

    init(absolute: CGSize) {
        self.init(Length(.fixed, absolute.width), Length(.fixed, absolute.height))
    }

    var isWidthFlexible: Bool {
        return width.isFlexible
    }

    var isHeightFlexible: Bool {
        return height.isFlexible
    }

    var minSize: CGSize {
        return CGSize(width: width.min, height: height.min)
    }

    func renderValue(_ adjustment: Adjustment) -> CGSize {
        return CGSize(width: width.renderValue(adjustment.width),
                      height: height.renderValue(adjustment.height))
    }
}

struct Length {
    let flexibility: Flexibility
    let min: CGFloat

    init(_ flexibility: Flexibility, _ min: CGFloat) {
        self.flexibility = flexibility
        self.min = min
    }

    enum Adjustment {
        case available(CGFloat)
        case extra(CGFloat)
    }

    var isFlexible: Bool {
        return flexibility.isFlexible
    }

    func renderValue(_ adjustment: Adjustment) -> CGFloat {
        switch flexibility {
        case .flexible:
            switch adjustment {
            case let .available(v): return max(min, v)
            case let .extra(e): return min + e
            }
        case .fixed:
            return min
        }
    }
}
