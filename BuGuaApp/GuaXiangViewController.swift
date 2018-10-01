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

class GuaXiangViewController: UIViewController {

    // MARK: - Views
    @IBOutlet weak var guaXiangView: GuaXiangView!
    @IBOutlet weak var guaGongLabel: BodyLabel!
    @IBOutlet weak var originalGuaNameLabel: BodyLabel!
    @IBOutlet weak var changedGuaNameLabel: BodyLabel!
    @IBOutlet weak var dateGanZhiLabel: BodyLabel!
    @IBOutlet var infoLabels: [BodyLabel]!
    var inputButton: UIBarButtonItem!
    
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
        additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        inputButton = UIBarButtonItem(title: NSLocalizedString("輸入", comment: ""), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = inputButton
    }

    func styling() {
        infoLabels.forEach { label in
            label.font = .scaled(.title2)
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
    }

    func activeBinding() {
        inputButton.rx.tap.bind(to: viewModel.onInputRelay).disposed(by: bag)
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
            let format = NSLocalizedString("%@年 %@月 %@日", comment: "")
            return String(format: format, $0.dateGanZhi.year.character,
                          $0.dateGanZhi.month.character, $0.dateGanZhi.day.character)
        }
    }
}
