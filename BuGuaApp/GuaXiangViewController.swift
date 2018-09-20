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

    // MARK: - Views
    @IBOutlet weak var guaXiangView: GuaXiangView!
    @IBOutlet weak var guaGongLabel: UILabel!
    @IBOutlet weak var originalGuaName: UILabel!
    @IBOutlet weak var changedGuaName: UILabel!
    @IBOutlet var mainLabels: [UILabel]!
    var inputButton: UIBarButtonItem!
    
    let viewModel: GuaXiangViewModel

    // MARK: - Private Rx
    private let bag = DisposeBag()

    // MARK: - Private UI
    private let styler: AppStyler

    // MARK: - Init
    init(viewModel: GuaXiangViewModel, styler: AppStyler) {
        self.viewModel = viewModel
        self.styler = styler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        styles()
        bindings()
    }
}

// MARK: - Setup
private extension GuaXiangViewController {
    
    func createViews() {
        inputButton = UIBarButtonItem(title: NSLocalizedString("輸入", comment: ""), style: .plain, target: nil, action: nil)
        styler.navigationBarItemize(inputButton)
        navigationItem.rightBarButtonItem = inputButton
    }
    
    func styles() {
        styler.appThemize(view)
        mainLabels.forEach { label in
            styler.guaXiangMain(label)
        }
    }
    
    func bindings() {
        viewModel.guaXiangRelay.bind(to: guaXiangView.guaXiangRelay).disposed(by: bag)
        viewModel.guaXiangRelay.map { "卦宮: " + $0.originalGua.guaGong.character }.bind(to: guaGongLabel.rx.text).disposed(by: bag)
//        viewModel.guaXiangRelay.map { "本卦: " + $0.originalGua. }

        

        inputButton.rx.tap.bind(to: viewModel.onInputRelay).disposed(by: bag)

        styler.changedRelay.map { [unowned self] _ in
            self.styler
        }.bind(to: guaXiangView.stylerRelay)
        .disposed(by: bag)
    }
}

extension AppFactory {
    func makeGuaXiangViewController(viewModel: GuaXiangViewModel) -> GuaXiangViewController {
        return GuaXiangViewController(viewModel: viewModel, styler: styler)
    }
}
