//
//  ThemeManager.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-19.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class BackgroundView: UIView {}
class BodyLabel: UILabel {}

protocol ThemeStoring {
    var currentSeq: Driver<Theme> { get }
}

class ThemeManager {
    
    let bag = DisposeBag()
    
    init(store: ThemeStoring) {
        store.currentSeq.drive(onNext: { [unowned self] theme in
            self.apply(theme)
        }).disposed(by: bag)
    }
    
    func apply(_ theme: Theme) {
        UIApplication.shared.delegate?.window??.tintColor = theme.tint
        
        applyBackgroundView(theme)
        applyNavigationBar(theme)
        applyBodyLabel(theme)
        applyGuaXiangView(theme)
        applyYaoView(theme)
        
        resetViews()
    }
    
    func applyBackgroundView(_ theme: Theme) {
        BackgroundView.appearance().backgroundColor = theme.background
    }
    
    func applyNavigationBar(_ theme: Theme) {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.isTranslucent = false
        navBarAppearance.barStyle = theme.navigationBarStyle
        navBarAppearance.barTintColor = theme.navigationBarTint
        navBarAppearance.titleTextAttributes = [.font: UIFont.title1, .foregroundColor: theme.bodyText]
        
        [UIControl.State.normal, .disabled, .highlighted].forEach {
            UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.title1], for: $0)
        }
    }
    
    func applyBodyLabel(_ theme: Theme) {
        BodyLabel.appearance().textColor = theme.bodyText
        BodyLabel.appearance().adjustsFontForContentSizeCategory = true
    }
    
    func applyGuaXiangView(_ theme: Theme) {
    }
    
    func applyYaoView(_ theme: Theme) {
        let yaoViewAppearance = YaoView.appearance()
        yaoViewAppearance.color = theme.bodyText
    }
    
    func resetViews() {
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows {
            let subviews = window.subviews as [UIView]
            for v in subviews {
                v.removeFromSuperview()
                window.addSubview(v)
            }
        }
    }
}
