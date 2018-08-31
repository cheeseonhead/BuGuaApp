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
    var yaoViews: [YaoView]!
    var shiYingLabels: [UILabel]!

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

        addViews()
        createConstraints()

        bindings()

        setStyle()
    }
}

// MARK: - Add Views
private extension GuaXiangView {
    func addViews() {
        setupYaoViews()
        setupShiYingLabels()
    }

    func setupYaoViews() {
        yaoViews = (1...6).map { makeYaoView(at: $0) }.map {
            addSubview($0)
            return $0
        }
    }

    func makeYaoView(at position: Int) -> YaoView {
        let yaoView = YaoView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))

        yaoView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 56, height: 36))
        }

        guaXiangRelay.map { $0.yao(at: position) }
            .bind(to: yaoView.yaoRelay)
            .disposed(by: bag)

        return yaoView
    }

    func setupShiYingLabels() {
        shiYingLabels = (1...6).map { makeShiYingLabel(at: $0) }.map {
            addSubview($0)
            return $0
        }
    }

    func makeShiYingLabel(at position: Int) -> UILabel {
        let label = UILabel(frame: .zero)

        guaXiangRelay.map { ($0.originalGua.shi, $0.originalGua.ying) }
            .bind { shi, ying in
                if position == shi {
                    label.text = "世"
                } else if position == ying {
                    label.text = "應"
                } else {
                    label.text = " "
                }
            }.disposed(by: bag)

        return label
    }
}

// MARK: - Constraints
private extension GuaXiangView {
    func createConstraints() {

        shiYingLabels.last!.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(8)
        }

        // Between same yao and shi ying
        zip(yaoViews, shiYingLabels).forEach { yaoView, shiYingLabel in
            shiYingLabel.snp.makeConstraints { make in
                make.bottom.equalTo(yaoView.snp.top)
            }
        }

        // In between different yao and shi ying
        zip(yaoViews.suffix(5), shiYingLabels.prefix(5)).forEach { upperYaoView, lowerShiYingLabel in
            lowerShiYingLabel.snp.makeConstraints({ make in
                make.top.equalTo(upperYaoView.snp.bottom).offset(16)
            })
        }

        yaoViews.forEach { $0.snp.makeConstraints { $0.centerX.equalToSuperview() } }
        shiYingLabels.forEach { $0.snp.makeConstraints { $0.centerX.equalToSuperview() } }
    }
}

// MARK: - Bindings
private extension GuaXiangView {
    func bindings() {
//        guaXiangRelay.map { $0.originalGua.innerGua }
//            .bind(to: innerGuaView.baGuaRelay)
//            .disposed(by: bag)
//
//        guaXiangRelay.map { $0.originalGua.outerGua }
//            .bind(to: outerGuaView.baGuaRelay)
//            .disposed(by: bag)


//        diZhiBindings()
//        liuQinBindings()
    }

//    func diZhiBindings() {
//        let diZhiStrings: Observable<[String?]> = guaXiangRelay.map { $0.originalGua.yaoZhi }
//            .map { $0.map { $0.character + $0.wuXing.character } }
//
//        let textObservables = (0..<diZhiLabels.count).map { index in
//            diZhiStrings.map { $0[index] }
//        }
//
//        zip(textObservables, diZhiLabels).map { stringRelay, label in
//            stringRelay.bind(to: label.rx.text)
//        }.forEach { $0.disposed(by: bag) }
//    }
//
//    func liuQinBindings() {
//        let liuQinStrings: Observable<[String?]> = guaXiangRelay.map { $0.originalGua.liuQin }
//            .map { $0.map { $0.character } }
//
//        let textObservables = (0..<liuQinLabels.count).map { index in
//            liuQinStrings.map { $0[index] }
//        }
//
//        zip(textObservables, liuQinLabels).map { stringRelay, label in
//            stringRelay.bind(to: label.rx.text)
//        }.forEach { $0.disposed(by:bag) }
//    }
}

// MARK: - Styling
extension GuaXiangView {
    func setStyle() {
        shiYingLabels.forEach { label in
            label.font = .headline
            label.textColor = .spaceGrey
        }
    }
}
