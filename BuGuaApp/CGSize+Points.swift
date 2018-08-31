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
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
}
