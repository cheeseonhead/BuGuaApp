//
//  BuGuaEntryViewController.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-24.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

private enum Style {
    static let verticalInset = BGStyle.standardMargin
    static let horizontalSpacing = BGStyle.standardMargin
    static let cardSpacing = horizontalSpacing
}

class BuGuaEntryViewController: UIViewController {

    // MARK: - Views

    let inputButton = UIBarButtonItem(title: NSLocalizedString("輸入", comment: ""), style: .plain, target: nil, action: nil)

    // MARK: - View Controllers

    var pageController: BGPageController!
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
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view = BackgroundView(frame: .zero)

        setup()
    }
}

// MARK: - Setup

private extension BuGuaEntryViewController {
    func setup() {
        createViews()
        constraints()
        bindings()
        styling()
    }

    func createViews() {
        let viewModel = factory.makeGuaXiangViewModel()
        guaXiangVC = factory.makeGuaXiangViewController(viewModel: viewModel)

        entryInfoVC = factory.makeBuGuaInfoViewController()

        pageController = BGPageController(viewControllers: [guaXiangVC, entryInfoVC])
        pageController.minimumMultiPageWidth = 400
        pageController.inset = 24
        pageController.minimumPageSpacing = 16

        add(pageController)

        navigationItem.rightBarButtonItem = inputButton
    }

    func constraints() {
        pageController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
