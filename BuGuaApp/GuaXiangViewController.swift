//
//  GuaXiangViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class GuaXiangViewController: UIViewController {

    @IBOutlet weak var guaXiangView: GuaXiangView!
    @IBOutlet weak var inputButton: UIButton!
    
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
        
        styles()
        bindings()
    }
}

// MARK: - Setup
private extension GuaXiangViewController {
    
    func styles() {
        view.tintColor = .mars
        inputButton.titleLabel?.font = .title1
    }
    
    func bindings() {
        viewModel.guaXiangRelay.bind(to: guaXiangView.guaXiangRelay).disposed(by: bag)
        
        inputButton.rx.tap.bind(to: viewModel.onInputRelay).disposed(by: bag)
    }
}
