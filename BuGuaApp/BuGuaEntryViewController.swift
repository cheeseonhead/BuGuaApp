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
    let inputButton = UIBarButtonItem(title: NSLocalizedString("輸入", comment: ""), style: .plain, target: nil, action: nil)
    
    // MARK: - View Controllers
    var guaXiangVC: GuaXiangViewController!
    
    // MARK: - Rx
    let bag = DisposeBag()
    
    // MARK: - Properties
    let factory: AppFactory
    let viewModel: BuGuaEntryViewModel
    
    // MARK: - Inits
    init(factory: AppFactory, viewModel: BuGuaEntryViewModel) {
        self.factory = factory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = BackgroundView(frame: .zero)
        
        let viewModel = factory.makeGuaXiangViewModel()
        guaXiangVC = factory.makeGuaXiangViewController(viewModel: viewModel)
        
        add(guaXiangVC)
        
        setup()
    }
}

// MARK: - Setup
private extension BuGuaEntryViewController {
    func setup() {
        constraints()
        bindings()
        styling()
    }
    
    func createViews() {
        navigationItem.rightBarButtonItem = inputButton
    }
    
    func constraints() {
        guaXiangVC.view.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func styling() {
    }
    
    func bindings() {
        
    }
}

extension AppFactory {
    func makeBuGuaEntryViewController(viewModel: BuGuaEntryViewModel) -> BuGuaEntryViewController {
        return BuGuaEntryViewController(factory: self, viewModel: viewModel)
    }
}
