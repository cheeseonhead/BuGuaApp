//
//  AppStyler.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-19.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

class AppStyler {

    let changedRelay = BehaviorRelay<()>(value: ())

    let appTintColor = UIColor.mars
    let backgroundColor = UIColor.baige
    let bodyColor = UIColor.spaceGrey
    let errorColor = UIColor.scarlet

    // MARK: - UIView
    func appThemize(_ view: UIView) {
        view.tintColor = appTintColor
        view.backgroundColor = backgroundColor
    }

    // MARK: - Labels
    func appColorize(_ label: UILabel) {
        label.textColor = bodyColor
    }

    func navigationTitlize(_ label: UILabel) {
        label.textColor = bodyColor
        label.font = .title1
    }

    func errorize(_ label: UILabel) {
        label.textColor = .scarlet
        label.font = .body2
    }

    // MARK: - Gua Xiang View
    func guaXiangMain(_ label: UILabel) {
        label.textColor = bodyColor
        label.font = .headline
    }

    // MARK: - Buttons
    func navigationBarItemize(_ barItem: UIBarItem) {
        barItem.setTitleTextAttributes([.font: UIFont.title1], for: UIControl.State())
    }
}
