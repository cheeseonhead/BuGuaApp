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
    let finishBarButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("完成", comment: ""), style: .done, target: nil, action: nil)

    // MARK: - Child VCs
    var timePickerViewController: TimePickerViewController!
    var timePickerViewModel: TimePickerViewModel!

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
        setupData()

        binding()
        styling()
    }

    func createTimePicker() {
        timePickerViewModel = factory.makeTimePickerViewModel()
        timePickerViewController = factory.makeTimePickerViewController(viewModel: timePickerViewModel)

        addChild(timePickerViewController)
        timePickerHolder.addSubview(timePickerViewController.view)
        timePickerViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        timePickerViewModel.gregorianTimeRelay
            .drive(viewModel.gregorianTimeInput)
            .disposed(by: bag)
    }

    func setupData() {
        navigationItem.title = NSLocalizedString("輸入時間", comment: "")

        todayButton.setTitle(NSLocalizedString("現在", comment: ""), for: .normal)

        navigationItem.rightBarButtonItem = finishBarButton
    }

    func binding() {
        viewModel.previewTextOutput
            .bind(to: previewLabel.rx.text)
            .disposed(by: bag)

        finishBarButton.rx.tap.bind(to: viewModel.finishInput).disposed(by: bag)

        todayButton.rx.tap.map { [unowned self] _ in self.currentDate() }
            .bind(to: timePickerViewController.timeInput)
            .disposed(by: bag)
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
