//
//  InputViewController.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftExt

class InputViewController: UIViewController {

    // MARK: - Views
    @IBOutlet weak var field1: UITextField!
    @IBOutlet weak var field2: UITextField!
    @IBOutlet weak var field3: UITextField!
    @IBOutlet var fields: [UITextField]!
    @IBOutlet weak var errorLabel: UILabel!
    let cancelBarButton = UIBarButtonItem(title: NSLocalizedString("取消", comment: ""), style: .plain, target: nil, action: nil)
    var finishBarButton: UIBarButtonItem!
    
    // MARK: - Rx
    let bag = DisposeBag()
    private (set) lazy var cancelOutput = cancelBarButton.rx.tap
    
    // MARK: - Private properties
    private let viewModel: InputViewModel
    private var textFieldDelegate: UITextFieldDelegate!
    private let finishRelay = PublishRelay<()>()
    
    init(viewModel: InputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        setupDelegate()
        styling()
        activeBinding()
        reactiveBindings()
    }
}

private extension InputViewController {

    func createViews() {
        finishBarButton = UIBarButtonItem(title: NSLocalizedString("下一個", comment: ""),
                                          style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = finishBarButton
        navigationItem.leftBarButtonItem = cancelBarButton

        navigationItem.title = NSLocalizedString("輸入卜卦數字", comment: "")
    }

    func setupDelegate() {
        let numberDelegate = NumericTextFieldDelegate()
        let autoNextDelegate = AutoNextTextFieldDelegate(textFields: [field1, field2, field3])
        textFieldDelegate = ComposedTextFieldDelegate(delegates: [numberDelegate, autoNextDelegate], &&)
        
        autoNextDelegate.finishRelay
            .bind(to: finishRelay)
            .disposed(by: bag)
    }
    
    func styling() {
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
    
    func activeBinding() {
        finishBarButton.rx.tap
            .bind(to: finishRelay)
            .disposed(by: bag)
        
        let strs = Observable.combineLatest(field1.rx.text, field2.rx.text, field3.rx.text) { (($0, $1), [$2]) }
        
        finishRelay.withLatestFrom(strs)
            .map { $0.0 }
            .bind(to: viewModel.guaStrRelay)
            .disposed(by: bag)
        
        finishRelay.withLatestFrom(strs)
            .map { $0.1 }
            .bind(to: viewModel.unstableYaoStrRelay)
            .disposed(by: bag)
    }
    
    func reactiveBindings() {
        
        viewModel.yaoTypeSignal.asObservable().elements()
            .mapTo(true)
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: bag)
        
        let errorStr = viewModel.yaoTypeSignal.asObservable().errors()
            .map { $0.localizedDescription }

        errorStr.mapTo(false).bind(to: errorLabel.rx.isHidden).disposed(by: bag)
        errorStr.bind(to: errorLabel.rx.text).disposed(by: bag)
    }
}

extension AppFactory {
    func makeInputViewController(viewModel: InputViewModel) -> InputViewController {
        return InputViewController(viewModel: viewModel)
    }
}
