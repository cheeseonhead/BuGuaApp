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
    let yaoView = ShiYingYaoView(frame: .zero)
    let stackView: UIStackView

    // MARK: - Inputs
    let bag = DisposeBag()
    let guaXiangRelay = PublishRelay<(LiuYaoGuaXiang, Int)>()

    // MARK: - Inits
    override init(frame: CGRect) {
        stackView = UIStackView(arrangedSubviews: [fuShenLabel,
                                                   changedLiuQinLabel,
                                                   liuQinLabel,
                                                   yaoView,
                                                   ganZhiLabel,
                                                   changedGanZhiLabel,
                                                   hiddenGanZhiLabel])
        super.init(frame: frame)

        stackView.axis = .horizontal
        stackView.spacing = Style.stackViewSpacing
        addSubview(stackView)

        constraints()
        bindings()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension GuaXiangRow {
    func constraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Style.stackViewInset)
        }
    }

    func bindings() {
        bindLabel(getFushen, fuShenLabel)
        bindLabel(getChangedLiuQin, liuQinLabel)
        bindLabel(getLiuQin, liuQinLabel)
        bindLabel(getGanZhi, ganZhiLabel)
        bindLabel(getChangedGanZhi, changedGanZhiLabel)
        bindLabel(getHiddenGanZhi, hiddenGanZhiLabel)
    }

    func bindLabel(_ operation: GuaXiangDescription, _ label: BodyLabel) {
        guaXiangRelay.apply(operation)
            .bind(to: label.rx.text)
            .disposed(by: bag)
    }
}

private extension GuaXiangRow {
    static func makeLabel() -> BodyLabel {
        let label = BodyLabel(frame: .zero)

        label.font = Style.labelFont
        return label
    }
}

// MARK: - Rx Convenience
private extension GuaXiangRow {

    typealias GuaXiangDescription = (Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String>

    func getFushen(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map {
            return $0.0.fuShenController.fuShen()[$0.1]?.character.vertical ?? ""
        }
    }

    func getChangedLiuQin(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.changedLiuQin[position]?.character.vertical ?? ""
        }
    }

    func getLiuQin(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.originalGua.liuQin[position].character.vertical
        }
    }

    func getGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.originalGua.ganZhi[position].character.vertical
        }
    }

    func getChangedGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map {
            return $0.0.changedTianGan[$0.1]?.character.vertical ?? ""
        }
    }

    func getHiddenGanZhi(_ guaXiangRelay: Observable<(LiuYaoGuaXiang, Int)>) -> Observable<String> {
        return guaXiangRelay.map { guaXiang, position in
            return guaXiang.fuShenController.hiddenGanZhi()[position]?.character.vertical ?? ""
        }
    }
}

private extension FuShenController {
    func hiddenGanZhi() -> [GanZhi?] {
        return zip(hiddenTianGan(), hiddenDiZhi()).map {
            guard let gan = $0, let zhi = $1 else { return nil }
            return GanZhi(gan, zhi)
        }
    }
}
