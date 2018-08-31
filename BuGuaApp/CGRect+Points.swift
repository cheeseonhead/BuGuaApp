//
//  CGRect+Points.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }

    var topRight: CGPoint {
        return origin + CGPoint(x: width, y: 0)
    }

    var bottomLeft: CGPoint {
        return origin + CGPoint(x: 0, y: height)
    }

    var bottomRight: CGPoint {
        return origin + CGPoint(x: width, y: height)
    }
}
