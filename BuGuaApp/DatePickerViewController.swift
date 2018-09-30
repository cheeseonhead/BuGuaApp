//
//  DateInputViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

class DatePickerViewController: UIViewController {

    // MARK: - Views
    @IBOutlet var datePicker: UIDatePicker!

    let viewModel: DatePickerViewModel

    // MARK: - Private Rx
    private let bag = DisposeBag()

    // MARK: - Init
    init(viewModel: DatePickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindings()
    }

    func bindings() {
        datePicker.rx.date
            .bind(to: viewModel.dateRelay)
            .disposed(by: bag)
    }
}

extension AppFactory {
    func makeDatePickerViewController(viewModel: DatePickerViewModel) -> DatePickerViewController {
        return DatePickerViewController(viewModel: viewModel)
    }
}
