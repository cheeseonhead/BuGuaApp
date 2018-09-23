//
//  GuaXiangRow.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-22.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import RxCocoa
import RxSwift
import RxSwiftExt
import Foundation
import UIKit

private enum Style {
    static let stackViewInset = BGStyle.standardMargin
    static let stackViewSpacing = BGStyle.standardMargin

    static let labelFont = UIFont.scaled(.body3Medium)
}

class GuaXiangRow: UIView {

    // MARK: - Labels
    let fuShenLabel = GuaXiangRow.makeLabel()
    let changedLiuQinLabel = GuaXiangRow.makeLabel()
    let liuQinLabel = GuaXiangRow.makeLabel()
    let ganZhiLabel = GuaXiangRow.makeLabel()
    let changedGanZhiLabel = GuaXiangRow.makeLabel()
    let hiddenGanZhiLabel = GuaXiangRow.makeLabel()

    // MARK: - Other views
    let shiYaoView = ShiYaoView(frame: .zero)

    // MARK: - Inputs
    let bag = DisposeBag()
    let guaXiangRelay = PublishRelay<(LiuYaoGuaXiang, Int)>()

    // MARK: - Inits
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
private extension GuaXiangRow {
    func setup() {
        backgroundColor = nil

        constraints()
        bindings()
    }

    func constraints() {
        let views = [fuShenLabel,
                     changedLiuQinLabel,
                     liuQinLabel,
                     shiYaoView,
                     ganZhiLabel,
                     changedGanZhiLabel,
                     hiddenGanZhiLabel]

        addSubviews(views)

        views.first!.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }

        views.last!.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
        }

        views.forEach {
            $0.snp.makeConstraints({ make in
                make.top.bottom.equalToSuperview()
            })
        }

        for i in 0..<views.count - 1 {
            let left = views[i]
            let right = views[i+1]

            left.snp.makeConstraints { (make) in
                make.trailing.equalTo(right.snp.leading).offset(-Style.stackViewSpacing)
            }
        }
    }

    func bindings() {
        bindLabel(getFushen, fuShenLabel)
        bindLabel(getChangedLiuQin, changedLiuQinLabel)
        bindLabel(getLiuQin, liuQinLabel)
        bindLabel(getGanZhi, ganZhiLabel)
        bindLabel(getChangedGanZhi, changedGanZhiLabel)
        bindLabel(getHiddenGanZhi, hiddenGanZhiLabel)

        guaXiangRelay.map { $0.0.yao(at: $0.1) }
            .bind(to: shiYaoView.yaoTypeRelay)
            .disposed(by: bag)

        guaXiangRelay.map { ($0.0.originalGua.shi == $0.1, $0.0.originalGua.ying == $0.1) }
            .map {
                if $0.0 {
                    return ShiYaoView.ShiYingType.shi
                } else if $0.1 {
                    return ShiYaoView.ShiYingType.ying
                } else {
                    return ShiYaoView.ShiYingType.none
                }
            }.bind(to: shiYaoView.shiYingTypeRelay)
            .disposed(by: bag)
    }

    func bindLabel(_ operation: GuaXiangDescription, _ label: BodyLabel) {
        let string = guaXiangRelay.apply(operation)

        string.map {
            if $0.isEmpty {
                return "詹"
            } else {
                return $0
            }
        }.bind(to: label.rx.text)
        .disposed(by: bag)

        string.map { $0.isEmpty }
            .bind(to: label.rx.isHidden)
            .disposed(by: bag)
    }
}

private extension GuaXiangRow {
    static func makeLabel() -> BodyLabel {
        let label = BodyLabel(frame: .zero)

        label.font = Style.labelFont
        label.numberOfLines = 2
        return label
    }
}

// MARK: - Rx Convenience
private extension GuaXiangRow {

    typealias GuaXiangDescription = (Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String>

    func getFushen(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map {
            return $0.0.fuShenController.fuShen(at: $0.1)?.character.vertical ?? ""
        }
    }

    func getChangedLiuQin(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.changedLiuQin(at: position)?.character.vertical ?? ""
        }
    }

    func getLiuQin(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.originalGua.liuQin(at: position).character.vertical
        }
    }

    func getGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.originalGua.ganZhi(at: position).character.vertical
        }
    }

    func getChangedGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map {
            return $0.0.changedGanZhi(at: $0.1)?.character.vertical ?? ""
        }
    }

    func getHiddenGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.fuShenController.hiddenGanZhi(at: position)?.character.vertical ?? ""
        }
    }
}
