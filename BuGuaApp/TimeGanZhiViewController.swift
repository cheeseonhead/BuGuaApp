//
//  TimeGanZhiViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit

class TimeGanZhiViewController: UIViewController {

    let viewModel: TimeGanZhiViewModel

    init(viewModel: TimeGanZhiViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension AppFactory {
    func makeTimeGanZhiViewController(viewModel: TimeGanZhiViewModel) -> TimeGanZhiViewController {
        return TimeGanZhiViewController(viewModel: viewModel)
    }
}
