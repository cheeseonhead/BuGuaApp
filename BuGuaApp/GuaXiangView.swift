//
//  GuaXiangView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-28.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import RxSwift
import RxCocoa
import SnapKit
import UIKit

class GuaXiangView: UIView {

    // MARK: - Views
    let guaXiangRows = (1...6).map { _ in return GuaXiangRow(frame: .zero) }
    let dividers = GuaXiangView.makeDividers()
    let headerView = HeaderLabelView(frame: .zero)

    // MARK: - Properties
    let guaXiangRelay = PublishRelay<LiuYaoGuaXiang>()

    // MARK: - Private Constants
    private let columnSpacing = 16
    
    // MARK: - Private
    let bag = DisposeBag()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }
}

// MARK: - Setup
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

    func createConstraints() {
        dividers.first!.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
        }
        dividers.last!.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }

        let viewStack = [
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
            dividers[7]
        ]

        stitchVertically(viewStack)

        GuaXiangViewLayout.alignHeader(headerView, firstRow: guaXiangRows[5])
    }

    func stitchVertically(_ views: [UIView]) {
        for i in 0..<views.count - 1 {
            let top = views[i]
            let down = views[i+1]

            top.snp.makeConstraints { (make) in
                make.bottom.equalTo(down.snp.top)
            }
        }

        views.forEach { v in
            v.snp.makeConstraints({ (make) in
                make.leading.trailing.equalToSuperview()
            })
        }
    }

    func bindings() {
        (1...6).forEach { position in
            guaXiangRelay.map { ($0, position) }
                .bind(to: guaXiangRows[position - 1].guaXiangRelay)
                .disposed(by: bag)
        }
    }
}

// MARK: - Setup Views
private extension GuaXiangView {
    static func makeDividers() -> [WideDivider] {
        let types: [WideDivider.Style] = [.thick, .thick, .default, .default, .thick, .default, .default, .default]

        return types.map { type in
            return WideDivider(style: type)
        }
    }
}
