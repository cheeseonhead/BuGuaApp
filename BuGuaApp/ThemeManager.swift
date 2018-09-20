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
        
        applyNavigationBar(theme)
        
        resetViews()
    }
    
    func applyNavigationBar(_ theme: Theme) {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.isTranslucent = false
        navBarAppearance.barStyle = theme.navigationBarStyle
        navBarAppearance.barTintColor = theme.navigationBarTint
        
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
    }}