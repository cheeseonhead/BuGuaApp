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
    static let stackViewSpacing = BGStyle.standardMargin * 1.5
    static let padding = 0

    static let labelFont = UIFont.scaled(.body3Medium)
}

class GuaXiangRow: UIView {

    // MARK: - Labels
    let liuShouLabel = GuaXiangRow.makeLabel()
    let fuShenLabel = GuaXiangRow.makeLabel()
    let changedLiuQinLabel = GuaXiangRow.makeLabel()
    let liuQinLabel = GuaXiangRow.makeLabel()
    let ganZhiLabel = GuaXiangRow.makeLabel()
    let changedGanZhiLabel = GuaXiangRow.makeLabel()
    let hiddenGanZhiLabel = GuaXiangRow.makeLabel()
    let guaShenLabel = GuaXiangRow.makeLabel()

    // MARK: - Other views
    let shiYaoView = ShiYaoView(frame: .zero)
    private (set) lazy var viewStack = [liuShouLabel,
                                        fuShenLabel,
                                        changedLiuQinLabel,
                                        liuQinLabel,
                                        shiYaoView,
                                        ganZhiLabel,
                                        changedGanZhiLabel,
                                        hiddenGanZhiLabel,
                                        guaShenLabel]

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
        addSubviews(viewStack)

        viewStack.first!.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Style.padding)
        }

        viewStack.last!.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-Style.padding)
        }

        viewStack.forEach {
            $0.snp.makeConstraints({ make in
                make.top.bottom.equalToSuperview().inset(Style.padding)
            })
        }

        for i in 0..<viewStack.count - 1 {
            let left = viewStack[i]
            let right = viewStack[i+1]

            left.snp.makeConstraints { (make) in
                make.trailing.equalTo(right.snp.leading).offset(-Style.stackViewSpacing)
            }
        }
    }

    func bindings() {
        bindLabel(GuaXiangRow.getLiuShou, liuShouLabel)
        bindLabel(GuaXiangRow.getFushen, fuShenLabel)
        bindLabel(GuaXiangRow.getChangedLiuQin, changedLiuQinLabel)
        bindLabel(GuaXiangRow.getLiuQin, liuQinLabel)
        bindLabel(GuaXiangRow.getGanZhi, ganZhiLabel)
        bindLabel(GuaXiangRow.getChangedGanZhi, changedGanZhiLabel)
        bindLabel(GuaXiangRow.getHiddenGanZhi, hiddenGanZhiLabel)
        bindLabel(GuaXiangRow.getGuaShen, guaShenLabel)

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

        label.text = "甲\n子"
        label.font = Style.labelFont
        label.numberOfLines = 2
        return label
    }
}

// MARK: - Rx Convenience
private extension GuaXiangRow {

    typealias GuaXiangDescription = (Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String>

    static func getFushen(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map {
            return $0.0.fuShenController.fuShen(at: $0.1)?.character.vertical ?? ""
        }
    }

    static func getChangedLiuQin(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.changedLiuQin(at: position)?.character.vertical ?? ""
        }
    }

    static func getLiuQin(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.originalGua.liuQin(at: position).character.vertical
        }
    }

    static func getGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.originalGua.ganZhi(at: position).character.vertical
        }
    }

    static func getChangedGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map {
            return $0.0.changedGanZhi(at: $0.1)?.character.vertical ?? ""
        }
    }

    static func getHiddenGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.fuShenController.hiddenGanZhi(at: position)?.character.vertical ?? ""
        }
    }
    
    static func getLiuShou(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.liuShouController.liuShou(at: position).character.vertical
        }
    }
    
    static func getGuaShen(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.guaShenController.guaShen(at: position)?.character ?? ""
        }
    }
}
