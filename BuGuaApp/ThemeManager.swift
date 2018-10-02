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

enum BGStyle {
    static let standardMargin: CGFloat = 16
}

class BackgroundView: UIView {}
class CardBackground: UIView {
    private static let corner = CGFloat(10)
    static let preferredEdgeInsets = UIEdgeInsets(top: corner, left: 0, bottom: corner, right: 0)

    @objc dynamic var cornerRadius = CardBackground.corner

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = cornerRadius
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = cornerRadius
    }
}

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
        applyBodyStyle(theme)
        applyGuaXiangView(theme)
        applyYaoView(theme)
        applyTableView(theme)
        applyDetailCell(theme)
        
        resetViews()
    }
    
    func applyBackgroundView(_ theme: Theme) {
        BackgroundView.appearance().backgroundColor = theme.background
        CardBackground.appearance().backgroundColor = theme.cardBackground
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
    
    func applyBodyStyle(_ theme: Theme) {
        BodyLabel.appearance().textColor = theme.bodyText
        BodyLabel.appearance().adjustsFontForContentSizeCategory = true
    }
    
    func applyGuaXiangView(_ theme: Theme) {
    }
    
    func applyYaoView(_ theme: Theme) {
        let yaoViewAppearance = YaoView.appearance()
        yaoViewAppearance.color = theme.bodyText
    }

    func applyTableView(_ theme: Theme) {
        UITableView.appearance().backgroundColor = nil
        UITableView.appearance().separatorStyle = .none
    }

    func applyDetailCell(_ theme: Theme) {
        MasterDetailCell.appearance().masterLabelWidth = BGStyle.standardMargin * 4
        MasterDetailCell.appearance().backgroundColor = nil
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
