//
//  GuaXiangView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-28.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Prelude
import RxCocoa
import RxSwift
import SnapKit
import UIKit

private enum Style {
    static let stackViewSpacing = BGStyle.standardMargin * 1.5
    static let padding = 0

    static let labelFont = UIFont.scaled(.body3Medium)
}

class GuaXiangView: UIView {
    // MARK: - Views

    let guaXiangRows = (1 ... 6).map { _ in return GuaXiangRow(frame: .zero) }
    let dividers = GuaXiangView.makeDividers()
    let headerView = HeaderLabelView(frame: .zero)
    lazy var viewStack = [
        dividers[0],
        headerView,
        dividers[1],
        guaXiangRows[5],
        dividers[2],
        guaXiangRows[4],
        dividers[3],
        guaXiangRows[3],
        dividers[4],
        guaXiangRows[2],
        dividers[5],
        guaXiangRows[1],
        dividers[6],
        guaXiangRows[0],
        dividers[7],
    ]

    // MARK: - Properties

    let guaXiangRelay = PublishRelay<LiuYaoGuaXiang>()

    // MARK: - Private Constants

    private let columnSpacing = 16

    // MARK: - Private

    let bag = DisposeBag()
    private var spacingConstraints: [Constraint] = []

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        adjustRows()
    }
}

// MARK: - Setup

private extension GuaXiangView {
    typealias CharacterKeyPath = KeyPath<LiuYaoGuaXiang, [CharacterDescribable]>

    func createRow(_ position: Int) -> Layout {
        let textObservable = GuaXiangView.createObservable(guaXiangRelay, position: position)
    }

    func infoLabel(_ observable: @escaping (CharacterKeyPath) -> Observable<String>) -> (CharacterKeyPath) -> BodyLabel {
        return { keyPath in
            let label = GuaXiangView.makeLabel()
            observable(keyPath).bind(to: label.rx.text).disposed(by: bag)
        }
    }

    static func createObservable(_ guaXiangRelay: PublishRelay<LiuYaoGuaXiang>, position: Int) -> (CharacterKeyPath) -> Observable<String> {
        return { keyPath in
            guaXiangRelay.map(^keyPath).map { $0[position].character }
        }
    }
}

extension Optional: CharacterDescribable where Wrapped: CharacterDescribable {
    public var character: String {
        return map(^\.character) ?? ""
    }
}

private extension GuaXiangView {
    func setupViews() {
        backgroundColor = nil

        addViews()
        createConstraints()

        bindings()
    }

    func addViews() {
        addSubviews(guaXiangRows)
        addSubviews(dividers)
        addSubview(headerView)
    }

    func bindings() {
        (1 ... 6).forEach { position in
            guaXiangRelay.map { ($0, position) }
                .bind(to: guaXiangRows[position - 1].guaXiangRelay)
                .disposed(by: bag)
        }
    }
}

// MARK: - Create Views

private extension GuaXiangView {
    static func makeLabel() -> BodyLabel {
        let label = BodyLabel(frame: .zero)

        label.text = "甲\n子"
        label.font = Style.labelFont
        label.numberOfLines = 2
        return label
    }
}

// MARK: - Constraints

private extension GuaXiangView {
    func createConstraints() {
        stitchHeaderAndDividers()
        dividersEdgeToEdge()

        centerAllViews(viewStack)

        let headerViewBelow = Array(viewStack[2...])
        stitchAllBelowHeaderView(headerViewBelow)

        GuaXiangViewLayout.alignHeader(headerView, firstRow: guaXiangRows[5])
    }

    func stitchHeaderAndDividers() {
        dividers.first!.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(headerView.snp.top)
        }

        headerView.snp.makeConstraints { make in
            make.bottom.equalTo(dividers[1].snp.top)
        }
    }

    func dividersEdgeToEdge() {
        dividers.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }

    func centerAllViews(_ views: [UIView]) {
        views.forEach { v in
            v.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
            })
        }
    }

    func stitchAllBelowHeaderView(_ views: [UIView]) {
        for i in 0 ..< views.count - 1 {
            let top = views[i]
            let down = views[i + 1]

            top.snp.makeConstraints { make in
                spacingConstraints.append(make.bottom.equalTo(down.snp.top).constraint)
            }
        }
    }

    // MARK: - Adjustment

    func adjustRows() {
        let bottomDivider = dividers.last!
        let bottomY = bottomDivider.frame.bottomLeft.y

        let extraSpace = frame.bottomLeft.y - bottomY
        let spacing = extraSpace / 12

        let topRowBelow = Array(viewStack[3...])

        var pos = dividers[1].frame.bottomLeft.y
        for v in topRowBelow {
            pos += spacing
            v.frame = CGRect(x: v.frame.origin.x, y: pos, width: v.frame.size.width, height: v.frame.size.height)
            pos += v.frame.height
        }
    }
}

// MARK: - Setup Views

private extension GuaXiangView {
    static func makeDividers() -> [WideDivider] {
        let types: [WideDivider.Style] = [.thick, .thick, .default, .default, .thick, .default, .default, .default]

        return types.map { type in
            WideDivider(style: type)
        }
    }
}

extension Array where Element: UIView {
    func makeConstraints(_ closure: (ConstraintMaker) -> Void) {
        forEach { element in
            element.snp.makeConstraints({ make in
                closure(make)
            })
        }
    }
}
