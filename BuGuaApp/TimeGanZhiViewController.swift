//
//  TimeGanZhiViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit

class TimeGanZhiViewController: UIViewController {

    // MARK: - Views
    @IBOutlet var timePickerHolder: UIView!

    // MARK: - Child VCs
    var timePickerViewController: TimeInputViewController!

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
    }

    func createTimePicker() {
        let timePickerViewModel = factory.makeTimeInputViewModel()
        timePickerViewController = factory.makeTimeInputViewController(viewModel: timePickerViewModel)

        timePickerHolder.addSubview(timePickerViewController.view)
        timePickerViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AppFactory {
    func makeTimeGanZhiViewController(viewModel: TimeGanZhiViewModel) -> TimeGanZhiViewController {
        return TimeGanZhiViewController(factory: self, viewModel: viewModel, currentDate: { Date() })
    }
}
