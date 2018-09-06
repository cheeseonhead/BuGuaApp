//
//  InputViewController.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    // MARK: - Views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var thirdField: UITextField!
    @IBOutlet var fields: [UITextField]!
    
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
        
        styling()
    }
}

private extension InputViewController {
    func styling() {
        titleLabel.textColor = .spaceGrey
        titleLabel.font = .title2
        finishButton.titleLabel?.font = .title1
        
        let numberDelegate = NumericTextFieldDelegate()
        let autoNextDelegate = AutoNextTextFieldDelegate(textFields: [firstField, secondField, thirdField])
        textFieldDelegate = ComposedTextFieldDelegate(delegates: [numberDelegate, autoNextDelegate], &&)
        
        fields.forEach { field in
            field.font = .headline
            field.delegate = textFieldDelegate
        }
    }
}

extension AppFactory {
    func makeInputViewController(viewModel: InputViewModel) -> InputViewController {
        return InputViewController(viewModel: viewModel)
    }
}
