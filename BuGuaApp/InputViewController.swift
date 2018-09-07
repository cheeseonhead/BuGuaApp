//
//  InputViewController.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit
import RxSwift

class InputViewController: UIViewController {

    // MARK: - Views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var field1: UITextField!
    @IBOutlet weak var field2: UITextField!
    @IBOutlet weak var field3: UITextField!
    @IBOutlet var fields: [UITextField]!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Rx
    let bag = DisposeBag()
    
    // MARK: - Private properties
    private let viewModel: InputViewModel
    private var textFieldDelegate: UITextFieldDelegate!
    
    init(viewModel: InputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        styling()
        bindings()
    }
}

private extension InputViewController {
    func setupDelegate() {
        let numberDelegate = NumericTextFieldDelegate()
        let autoNextDelegate = AutoNextTextFieldDelegate(textFields: [field1, field2, field3])
        textFieldDelegate = ComposedTextFieldDelegate(delegates: [numberDelegate, autoNextDelegate], &&)
        
        autoNextDelegate.finishRelay.withLatestFrom(Observable.combineLatest(field1.rx.text, field2.rx.text, field3.rx.text))
            .map { str1, str2, str3 in
                return InputViewModel.Input<String?>(field1: str1, field2: str2, field3: str3)
            }.bind(to: viewModel.inputRelay)
            .disposed(by: bag)
    }
    
    func styling() {
        titleLabel.textColor = .spaceGrey
        titleLabel.font = .title2
        finishButton.titleLabel?.font = .title1
        
        errorLabel.textColor = .scarlet
        errorLabel.font = .title1
        errorLabel.isHidden = true
        
        field1.placeholder = "內掛數"
        field2.placeholder = "外掛數"
        field3.placeholder = "動爻數"
        
        fields.forEach { field in
            field.font = .headline
            field.delegate = textFieldDelegate
        }
    }
    
    func bindings() {
        viewModel.resultRelay.map { result in
            switch result {
            case .success: return true
            case .error: return false
            }
        }.bind(to: errorLabel.rx.isHidden)
        .disposed(by: bag)
        
        viewModel.resultRelay.map { result -> String? in
            switch result {
            case .success: return nil
            case .error(let error): return error.localizedDescription
            }
        }.bind(to: errorLabel.rx.text)
        .disposed(by: bag)
    }
}

extension AppFactory {
    func makeInputViewController(viewModel: InputViewModel) -> InputViewController {
        return InputViewController(viewModel: viewModel)
    }
}
