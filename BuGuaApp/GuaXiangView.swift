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
import UIKit

@IBDesignable
class GuaXiangView: UIView {

    // MARK: - Views
    var innerGuaView: FuXiBaGuaView!
    var outerGuaView: FuXiBaGuaView!
    var baGuaStackView: UIStackView!
    var diZhiLabels: [UILabel]!
    var liuQinLabels: [UILabel]!
    lazy var yaoInfoLabels = diZhiLabels + liuQinLabels

    // MARK: - Properties
    let guaXiangRelay = PublishRelay<LiuYaoGuaXiang>()

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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = nil

        setupBaGuaViews()
        setupDiZhiLabels()
        setupLiuQinLabels()

        bindings()
    }

    func setupBaGuaViews() {

        innerGuaView = makeBaGuaView()
        outerGuaView = makeBaGuaView()

        baGuaStackView = UIStackView(arrangedSubviews: [outerGuaView, innerGuaView])
        baGuaStackView.translatesAutoresizingMaskIntoConstraints = false

        baGuaStackView.axis = .vertical
        baGuaStackView.spacing = 48


        addSubview(baGuaStackView)
        baGuaStackView.center(useSafeArea: true)
            .anchorFillHeight(useSafeArea: true)
    }

    func makeBaGuaView() -> FuXiBaGuaView {
        let baGuaView = FuXiBaGuaView(frame: CGRect.zero)
        baGuaView.heightAnchor.constraint(equalTo: baGuaView.widthAnchor).isActive = true

        return baGuaView
    }

    func setupDiZhiLabels() {
        diZhiLabels = [innerGuaView, outerGuaView].lazy.flatMap { $0.centerViews }
            .map { createDiZhiLabel(to: $0) }
    }

    func createDiZhiLabel(to yaoView: UIView) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        let horizontalSpacing: CGFloat = 24

        label.leadingAnchor.constraint(equalTo: baGuaStackView.trailingAnchor, constant: horizontalSpacing).isActive = true
        label.centerYAnchor.constraint(equalTo: yaoView.centerYAnchor).isActive = true

        return label
    }

    func setupLiuQinLabels() {
        liuQinLabels = [innerGuaView, outerGuaView].lazy.flatMap { $0.centerViews }
            .map { createLiuQinLabels(to: $0) }
    }

    func createLiuQinLabels(to yaoView: UIView) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        let horizontalSpacing: CGFloat = 24

        baGuaStackView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: horizontalSpacing).isActive = true
        label.centerYAnchor.constraint(equalTo: yaoView.centerYAnchor).isActive = true

        return label
    }
}

// MARK: - Bindings
private extension GuaXiangView {
    func bindings() {
        guaXiangRelay.map { $0.originalGua.innerGua }
            .bind(to: innerGuaView.baGuaRelay)
            .disposed(by: bag)

        guaXiangRelay.map { $0.originalGua.outerGua }
            .bind(to: outerGuaView.baGuaRelay)
            .disposed(by: bag)

        diZhiBindings()
        liuQinBindings()
    }

    func diZhiBindings() {
        let diZhiStrings: Observable<[String?]> = guaXiangRelay.map { $0.originalGua.yaoZhi }
            .map { $0.map { $0.character + $0.wuXing.character } }

        let textObservables = (0..<diZhiLabels.count).map { index in
            diZhiStrings.map { $0[index] }
        }

        zip(textObservables, diZhiLabels).map { stringRelay, label in
            stringRelay.bind(to: label.rx.text)
        }.forEach { $0.disposed(by: bag) }
    }

    func liuQinBindings() {
        let liuQinStrings: Observable<[String?]> = guaXiangRelay.map { $0.originalGua.liuQin }
            .map { $0.map { $0.character } }

        let textObservables = (0..<liuQinLabels.count).map { index in
            liuQinStrings.map { $0[index] }
        }

        zip(textObservables, liuQinLabels).map { stringRelay, label in
            stringRelay.bind(to: label.rx.text)
        }.forEach { $0.disposed(by:bag) }
    }
}
