//
//  DateGanZhiViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit

class DateGanZhiViewController: UIViewController {

    @IBOutlet var dateInputHolder: UIView!
    @IBOutlet var ganZhiPreviewLabel: UILabel!

    // MARK - Public Properties
    let viewModel: DateGanZhiViewModel

    // MARK; - Init
    init(viewModel: DateGanZhiViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension AppFactory {
    func makeDateGanZhiViewController(viewModel: DateGanZhiViewModel) -> DateGanZhiViewController {
        return DateGanZhiViewController(viewModel: viewModel)
    }
}
