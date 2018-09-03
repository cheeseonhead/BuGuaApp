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
    var horizontalDividers: [UIView]!
    var cellSpacers: [UIView]!
    var diZhiLabels: [UILabel]!
    var liuQinLabels: [UILabel]!

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

    func addViews() {
        setupYaoViews()
        setupShiYingLabels()
        setupHorizontalDividers()
        setupCellSpacers()
        setupDiZhiLabels()
        setupLiuQinLabels()
    }

    func createConstraints() {
        shiYingConstraints()
        horizontalDividerConstraints()
        cellSpacerConstraints()
        diZhiConstraints()
        liuQinConstraints()
    }

    func bindings() {

    }

    func setStyle() {
        (diZhiLabels + shiYingLabels + liuQinLabels).forEach { label in
            label.font = .headline
            label.textColor = .spaceGrey
        }
    }
}

// MARK: - Yao Views
private extension GuaXiangView {

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
}

// MARK: - Shi Ying Labels
private extension GuaXiangView {

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

    func shiYingConstraints() {

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

// MARK: - Horizontal Dividers
private extension GuaXiangView {
    func setupHorizontalDividers() {
        horizontalDividers = (1...7).map { _ in makeHorizontalDividers() }.map {
            addSubview($0)
            return $0
        }
    }

    func makeHorizontalDividers() -> UIView {
        let divider = UIView(frame: .zero)
        divider.backgroundColor = UIColor(named: "Sunset")

        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }

        return divider
    }

    func horizontalDividerConstraints() {
        horizontalDividers.first!.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(shiYingLabels.last!.snp.top).offset(-8)
        }

        zip(horizontalDividers.suffix(6), yaoViews.reversed()).forEach { belowDivider, yaoView in
            belowDivider.snp.makeConstraints { make in
                make.top.equalTo(yaoView.snp.bottom).offset(8)
            }
        }

        horizontalDividers.map { $0.snp.makeConstraints }
            .forEach { maker in
                maker { make in
                    make.width.equalToSuperview()
                }
        }
    }
}

// MARK: - Cell spacers
private extension GuaXiangView {
    func setupCellSpacers() {
        cellSpacers = (1...6).map { _ in
            makeCellSpacers()
        }.map { (spacer) -> UIView in
                addSubview(spacer)
                return spacer
        }
    }

    func makeCellSpacers() -> UIView {
        let spacer = UIView(frame: .zero)
        spacer.backgroundColor = nil
        spacer.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        return spacer
    }

    func cellSpacerConstraints() {
        cellSpacers.forEach { spacer in
            spacer.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
            })
        }
        zip(horizontalDividers.prefix(6), cellSpacers.reversed()).forEach { above, spacer in
            spacer.snp.makeConstraints { make in
                make.top.equalTo(above.snp.bottom)
            }
        }

        zip(horizontalDividers.suffix(6), cellSpacers.reversed()).forEach { below, spacer in
            spacer.snp.makeConstraints { make in
                make.bottom.equalTo(below.snp.top)
            }
        }
    }
}

// MARK: - DiZhi Labels
private extension GuaXiangView {
    func setupDiZhiLabels() {
        diZhiLabels = (1...6).map { makeDiZhiLabel(at: $0) }.map { label in
            addSubview(label)
            return label
        }
    }

    func makeDiZhiLabel(at position: Int) -> UILabel {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0

        guaXiangRelay.map { $0.originalGua.yaoZhi(at: position) }
            .bind { diZhi in
                label.text = diZhi.character
            }.disposed(by: bag)

        return label
    }

    func diZhiConstraints() {
        zip(diZhiLabels, cellSpacers).forEach { label, spacer in
            label.snp.makeConstraints { make in
                make.centerY.equalTo(spacer.snp.centerY)
            }
        }

        zip(diZhiLabels, yaoViews).forEach { label, yaoView in
            label.snp.makeConstraints { make in
                make.leading.equalTo(yaoView.snp.trailing).offset(24)
            }
        }
    }
}

// MARK: - LiuQin Labels
private extension GuaXiangView {
    func setupLiuQinLabels() {
        liuQinLabels = (1...6).map { makeLiuQinLabel(at: $0) }.map { label in
            addSubview(label)
            return label
        }
    }

    func makeLiuQinLabel(at position: Int) -> UILabel {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0

        guaXiangRelay.map { $0.originalGua.liuQin(at: position) }
            .bind { liuQin in
                label.text = liuQin.character.vertical
            }.disposed(by: bag)

        return label
    }

    func liuQinConstraints() {
        zip(liuQinLabels, cellSpacers).forEach { label, spacer in
            label.snp.makeConstraints { make in
                make.centerY.equalTo(spacer.snp.centerY)
            }
        }

        zip(liuQinLabels, yaoViews).forEach { label, yaoView in
            label.snp.makeConstraints { make in
                make.trailing.equalTo(yaoView.snp.leading).offset(-24)
            }
        }
    }
}

private extension String {
    var vertical: String {
        forEach { c in
            print(c)
        }
        return lazy.map { String($0) }.joined(separator: "\n")
    }
}

// MARK: - Bindings
private extension GuaXiangView {
//        guaXiangRelay.map { $0.originalGua.innerGua }
//            .bind(to: innerGuaView.baGuaRelay)
//            .disposed(by: bag)
//
//        guaXiangRelay.map { $0.originalGua.outerGua }
//            .bind(to: outerGuaView.baGuaRelay)
//            .disposed(by: bag)


//        diZhiBindings()
//        liuQinBindings()

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
