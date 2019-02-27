//
//  CGSize+Points.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    init(_ point: CGPoint) {
        self.init(width: point.x, height: point.y)
    }

    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }

    func fits(_ inner: CGSize) -> Bool {
        return inner.width <= width && inner.height <= height
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return apply(-)(lhs, rhs)
    }

    private static func apply(_ f: @escaping (CGFloat, CGFloat) -> CGFloat) -> (CGSize, CGSize) -> CGSize {
        return { lhs, rhs in
            CGSize(width: f(lhs.width, rhs.width), height: f(lhs.height, rhs.height))
        }
    }
}
