//
//  GuaXiangViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import UIKit

private enum Style {
    static let infoLabelFont = UIFont.scaled(.title2)
}

class GuaXiangViewController: UIViewController {

    // MARK: - Views
    @IBOutlet weak var guaXiangView: GuaXiangView!
    @IBOutlet weak var guaGongLabel: BodyLabel!
    @IBOutlet weak var originalGuaNameLabel: BodyLabel!
    @IBOutlet weak var changedGuaNameLabel: BodyLabel!
    @IBOutlet weak var dateGanZhiLabel: BodyLabel!
    @IBOutlet weak var timeGanZhiLabel: BodyLabel!
    @IBOutlet var infoLabels: [BodyLabel]!
    
    let viewModel: GuaXiangViewModel

    // MARK: - Private Rx
    private let bag = DisposeBag()

    // MARK: - Init
    init(viewModel: GuaXiangViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        styling()
        reactiveBinding()
        activeBinding()
    }
}

// MARK: - Setup
private extension GuaXiangViewController {
    
    func createViews() {
        additionalSafeAreaInsets = CardBackground.preferredEdgeInsets
    }

    func styling() {
        infoLabels.forEach { label in
            label.font = Style.infoLabelFont
        }
    }

    func reactiveBinding() {
        viewModel.guaXiangRelay.bind(to: guaXiangView.guaXiangRelay).disposed(by: bag)

        viewModel.guaXiangRelay
            .formatGuaGong()
            .bind(to: guaGongLabel.rx.text)
            .disposed(by: bag)

        viewModel.guaXiangRelay.formatOriginalGuaName()
            .bind(to: originalGuaNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.guaXiangRelay.formatChangedGuaName()
            .bind(to: changedGuaNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.guaXiangRelay.formatDateGanZhi()
            .bind(to: dateGanZhiLabel.rx.text)
            .disposed(by: bag)

        viewModel.guaXiangRelay.formatTimeGanZhi()
            .bind(to: timeGanZhiLabel.rx.text)
            .disposed(by: bag)
    }

    func activeBinding() {
    }
}

private extension BehaviorRelay where Element == LiuYaoGuaXiang {
    func formatGuaGong() -> Observable<String> {
        return map {
            return ($0.originalGua.guaGong.character, $0.originalGua.guaGong.wuXing.character)
        }.map {
            let format = NSLocalizedString("卦宮: %@(%@)", comment: "")
            return String(format: format, $0.0, $0.1)
        }
    }

    func formatOriginalGuaName() -> Observable<String> {
        return map {
            let format = NSLocalizedString("主卦: %@", comment: "")
            return String(format: format, $0.originalGua.character)
        }
    }

    func formatChangedGuaName() -> Observable<String> {
        return map {
            let format = NSLocalizedString("變卦: %@", comment: "")
            return String(format: format, $0.changedGua.character)
        }
    }

    func formatDateGanZhi() -> Observable<String> {
        return map {
            let format = NSLocalizedString("%@年 %@月 %@日", comment: "日期地支")
            return String(format: format, $0.dateGanZhi.year.character,
                          $0.dateGanZhi.month.character, $0.dateGanZhi.day.character)
        }
    }

    func formatTimeGanZhi() -> Observable<String> {
        return map {
            let format = NSLocalizedString("%@時", comment: "時間地支")
            return String(format: format, $0.timeDiZhi.character)
        }
    }
}
