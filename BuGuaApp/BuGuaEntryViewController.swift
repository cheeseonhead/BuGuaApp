//
//  BuGuaEntryViewController.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-24.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import UIKit

class BuGuaEntryViewController: UIViewController {
    // MARK: - Views
    var inputButton: UIBarButtonItem!
    
    // MARK: - Rx
    let bag = DisposeBag()
    
    // MARK: - Properties
    let viewModel: BuGuaEntryViewModel
    
    // MARK: - Inits
    init(viewModel: BuGuaEntryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension BuGuaEntryViewController {
    func createViews() {
        view = BackgroundView(frame: .zero)
        inputButton = UIBarButtonItem(title: NSLocalizedString("輸入", comment: ""), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = inputButton
    }
    
    func styling() {
    }
    
    func bindings() {
    }
}

extension AppFactory {
    func makeBuGuaEntryViewController(viewModel: BuGuaEntryViewModel) -> BuGuaEntryViewController {
        return BuGuaEntryViewController(viewModel: viewModel)
    }
}
