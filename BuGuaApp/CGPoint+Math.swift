//
//  CGPoint+Math.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    static func +(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return apply(a, b, +)
    }

    static func -(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return apply(a, b, -)
    }

    static func apply(_ a: CGPoint, _ b: CGPoint, _ function: (CGFloat, CGFloat) -> CGFloat) -> CGPoint {
        return CGPoint(x: function(a.x, b.x), y: function(a.y, b.y))
    }
}
