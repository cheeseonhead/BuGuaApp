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

        bindings()

        setStyle()
    }
}

// MARK: - Add Views
private extension GuaXiangView {
    func addViews() {
        setupYaoViews()
    }

    func setupYaoViews() {
        (1...6).map { makeYaoView(at: $0) }.forEach { addSubview($0) }
    }

    func makeYaoView(at position: Int) -> YaoView {
        let yaoView = YaoView(frame: .zero)
        yaoView.translatesAutoresizingMaskIntoConstraints = false

        guaXiangRelay.map { $0.liuYao[position] }
            .bind(to: yaoView.yaoRelay)
            .disposed(by: bag)

        return yaoView
    }

    func setupShiYingLabels() {
        (1...6).map { makeShiYingLabel(at: $0) }.forEach { addSubview($0) }
    }

    func makeShiYingLabel(at position: Int) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

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

        guaXiangRelay.map { $0.liuYao }
            .bind { [unowned self] yaoTypes in
                self.yaoViews.forEach { yaoView in
                    yaoView.yaoRelay.accept(yaoTypes[yaoView.tag - 1])
                }
            }.disposed(by: bag)

        guaXiangRelay.map { ($0.originalGua.shi, $0.originalGua.ying) }
            .bind { [unowned self] shi, ying in
                self.shiYingLabels.forEach { shiYingLabel in
                    if shiYingLabel.tag == shi {
                        shiYingLabel.text = "世"
                    } else if shiYingLabel.tag == ying {
                        shiYingLabel.text = "應"
                    } else {
                        shiYingLabel.text = " "
                    }
                }
            }.disposed(by: bag)

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
