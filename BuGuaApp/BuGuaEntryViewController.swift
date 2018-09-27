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

private enum Style {
    static let guaXiangWidth = CGFloat(400)
}

class BuGuaEntryViewController: UIViewController {
    // MARK: - Views
    let inputButton = UIBarButtonItem(title: NSLocalizedString("輸入", comment: ""), style: .plain, target: nil, action: nil)
    
    // MARK: - View Controllers
    var guaXiangVC: GuaXiangViewController!
    var entryInfoVC: BuGuaInfoViewController!
    
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

        entryInfoVC = factory.makeBuGuaInfoViewController()

        add(guaXiangVC)
        add(entryInfoVC)
        
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
            make.width.equalTo(Style.guaXiangWidth)
        }

        entryInfoVC.view.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(BGStyle.standardMargin)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(guaXiangVC.view)
        }
    }
    
    func styling() {
    }
    
    func bindings() {
        viewModel.entryRelay.map { $0.guaXiang }
            .bind(to: guaXiangVC.viewModel.guaXiangRelay)
            .disposed(by: bag)
    }
}

extension AppFactory {
    func makeBuGuaEntryViewController(viewModel: BuGuaEntryViewModel) -> BuGuaEntryViewController {
        return BuGuaEntryViewController(factory: self, viewModel: viewModel)
    }
}
