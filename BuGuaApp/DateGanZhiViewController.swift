//
//  DateGanZhiViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import SnapKit
import UIKit

class DateGanZhiViewController: UIViewController {

    // MARK: - Views
    @IBOutlet var dateInputHolder: UIView!
    @IBOutlet var ganZhiPreviewLabel: UILabel!

    // MARK: - Child VCs
    var dateInputViewController: DateInputViewController!

    // MARK - Public Properties
    let viewModel: DateGanZhiViewModel

    // MARK: - Private
    private let factory: AppFactory

    // MARK; - Init
    init(factory: AppFactory, viewModel: DateGanZhiViewModel) {
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        creation()
        styling()
        bindings()
    }
}

// MARK: - Setup
private extension DateGanZhiViewController {
    func creation() {
        createDateInput()
    }

    func createDateInput() {
        let viewModel = factory.makeDateInputViewModel()
        dateInputViewController = factory.makeDateInputViewController(viewModel: viewModel)

        addChild(dateInputViewController)
        dateInputHolder.addSubview(dateInputViewController.view)
        dateInputViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dateInputViewController.didMove(toParent: self)
    }

    func styling() {

    }

    func bindings() {

    }
}

extension AppFactory {
    func makeDateGanZhiViewController(viewModel: DateGanZhiViewModel) -> DateGanZhiViewController {
        return DateGanZhiViewController(factory: self, viewModel: viewModel)
    }
}
