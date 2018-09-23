//
//  ShiYaoView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-22.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

private enum Style {
    static let labelFont = UIFont.scaled(.body3Medium)
}

class ShiYaoView: UIView {

    enum ShiYingType {
        case shi, ying, none

        static let `default` = ShiYingType.shi

        var character: String {
            switch self {
            case .shi: return NSLocalizedString("世", comment: "")
            case .ying: return NSLocalizedString("應", comment: "")
            case .none: return " "
            }
        }
    }

    // MARK: - Views
    let label = UILabel(frame: .zero)
    let yaoView = YaoView(frame: .zero)

    var stackView: UIStackView!

    // MARK: - Input
    let bag = DisposeBag()
    let shiYingTypeRelay = BehaviorRelay(value: ShiYingType.default)
    let yaoTypeRelay = BehaviorRelay(value: YaoType.oldYin)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
}

// MARK: - Setup
private extension ShiYaoView {
    func setup() {
        stackView = UIStackView(arrangedSubviews: [label, yaoView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        addSubview(stackView)

        constarints()
        bindings()
        styling()
    }

    func constarints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        yaoView.snp.makeConstraints { (make) in
            make.size.equalTo(yaoView.preferredSize)
        }
    }

    func bindings() {
        shiYingTypeRelay.mapAt(\.character)
            .bind(to: label.rx.text)
            .disposed(by: bag)

        yaoTypeRelay.bind(to: yaoView.yaoRelay)
            .disposed(by: bag)
    }

    func styling() {
        label.font = Style.labelFont
    }
}
