//
//  TimeInputViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

class TimeInputViewController: UIViewController {

    // MARK: - Views
    @IBOutlet weak var timePicker: UIDatePicker!

    let viewModel: TimeInputViewModel

    // MARK: - Private Rx
    private let bag = DisposeBag()

    // MARK: - Init
    init(viewModel: TimeInputViewModel) {
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
        timePicker.rx.date
            .bind(to: viewModel.dateRelay)
            .disposed(by: bag)
    }
}

extension AppFactory {
    func makeTimeInputViewController(viewModel: TimeInputViewModel) -> TimeInputViewController {
        return TimeInputViewController(viewModel: viewModel)
    }
}
