//
//  TimeGanZhiViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

private enum Style {
    static let bodyButtonFont = UIFont.body3

    static let previewLabelFont = UIFont.scaled(.title2)
}

class TimeGanZhiViewController: UIViewController {

    // MARK: - Views
    @IBOutlet weak var timePickerHolder: UIView!
    @IBOutlet weak var previewLabel: BodyLabel!
    @IBOutlet weak var todayButton: UIButton!

    // MARK: - Child VCs
    var timePickerViewController: TimeInputViewController!

    // MARK: - Rx
    let bag = DisposeBag()

    // MARK: - Logic
    let factory: AppFactory
    let viewModel: TimeGanZhiViewModel
    let currentDate: () -> Date

    init(factory: AppFactory, viewModel: TimeGanZhiViewModel, currentDate: @escaping () -> Date) {
        self.viewModel = viewModel
        self.factory = factory
        self.currentDate = currentDate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
extension TimeGanZhiViewController {
    func setup() {
        createTimePicker()
        setupTodayButton()

        styling()
    }

    func createTimePicker() {
        let timePickerViewModel = factory.makeTimeInputViewModel()
        timePickerViewController = factory.makeTimeInputViewController(viewModel: timePickerViewModel)

        timePickerHolder.addSubview(timePickerViewController.view)
        timePickerViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        timePickerViewModel.gregorianTimeRelay.map { $0.diZhi.character }
            .drive(previewLabel.rx.text).disposed(by: bag)
    }

    func setupTodayButton() {
        todayButton.setTitle(NSLocalizedString("現在", comment: ""), for: .normal)
    }

    func styling() {
        todayButton.titleLabel?.font = Style.bodyButtonFont

        previewLabel.font = Style.previewLabelFont
    }
}

extension AppFactory {
    func makeTimeGanZhiViewController(viewModel: TimeGanZhiViewModel) -> TimeGanZhiViewController {
        return TimeGanZhiViewController(factory: self, viewModel: viewModel, currentDate: { Date() })
    }
}
