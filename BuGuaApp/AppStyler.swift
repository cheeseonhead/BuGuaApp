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

    func errorize(_ label: UILabel) {
        label.textColor = .scarlet
        label.font = .body2
    }

    // MARK: - Buttons
    func navigationBarItemize(_ barItem: UIBarItem) {
        barItem.setTitleTextAttributes([.font: UIFont.title1], for: UIControl.State())
    }
}
