//
//  WideDivider.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-22.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

private enum ViewStyle {
    static let backgroundAlpha = CGFloat(0.5)
}

class WideDivider: UIView {

    enum Style {
        case `default`, thick
    }

    init(style: Style) {

        let height: CGFloat

        switch style {
        case .default: height = 1
        case .thick: height = 2
        }

        super.init(frame: .zero)

        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tintColorDidChange() {
        backgroundColor = tintColor.withAlphaComponent(ViewStyle.backgroundAlpha)
    }
}
