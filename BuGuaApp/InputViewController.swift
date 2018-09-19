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
    var finishBarButton: UIBarButtonItem!
    var titleLabel: UILabel!
    
    // MARK: - Rx
    let bag = DisposeBag()
    
    // MARK: - Private UI
    private let finishRelay = PublishRelay<()>()
    private let styler: AppStyler

    // MARK: - Private Model
    private let viewModel: InputViewModel
    private var textFieldDelegate: UITextFieldDelegate!
    
    init(viewModel: InputViewModel, styler: AppStyler) {
        self.viewModel = viewModel
        self.styler = styler
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
        bindings()
    }
}

private extension InputViewController {

    func createViews() {
        finishBarButton = UIBarButtonItem(title: NSLocalizedString("下一個", comment: ""),
                                          style: .plain, target: nil, action: nil)
        finishBarButton.setTitleTextAttributes([.font: UIFont.title1], for: UIControl.State())
        navigationItem.rightBarButtonItem = finishBarButton

        titleLabel = UILabel(frame: .zero)
        titleLabel.text = NSLocalizedString("輸入卜卦數字", comment: "")
        styler.navigationTitlize(titleLabel)
        navigationItem.titleView = titleLabel
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
    
    func bindings() {
        
        viewModel.yaoTypeSignal.asObservable().elements()
            .mapTo(true)
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: bag)
        
        let errorStr = viewModel.yaoTypeSignal.asObservable().errors()
            .mapAt(\.localizedDescription)
            
        errorStr.mapTo(false).bind(to: errorLabel.rx.isHidden).disposed(by: bag)
        errorStr.bind(to: errorLabel.rx.text).disposed(by: bag)
        
        let strs = Observable.combineLatest(field1.rx.text, field2.rx.text, field3.rx.text) { (($0, $1), [$2]) }
        
        finishRelay.withLatestFrom(strs)
            .map { $0.0 }
            .bind(to: viewModel.guaStrRelay)
            .disposed(by: bag)
        
        finishRelay.withLatestFrom(strs)
            .map { $0.1 }
            .bind(to: viewModel.unstableYaoStrRelay)
            .disposed(by: bag)

        finishBarButton.rx.tap
            .bind(to: finishRelay)
            .disposed(by: bag)
    }
}

extension AppFactory {
    func makeInputViewController(viewModel: InputViewModel) -> InputViewController {
        return InputViewController(viewModel: viewModel, styler: styler)
    }
}
