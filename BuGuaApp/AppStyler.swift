//
//  AppStyler.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-19.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

class AppStyler {

    let bodyColor = UIColor.spaceGrey

    // MARK: - Labels
    func navigationTitlize(_ label: UILabel) {
        label.textColor = bodyColor
        label.font = .title1
    }
}
