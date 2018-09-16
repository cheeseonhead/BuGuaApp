//
//  GuaXiangCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxSwift
import UIKit

class GuaXiangCoordinator: Coordinator {

    // MARK: - Coordinator
    var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()

    // MARK: - Private properties
    private var viewController: GuaXiangViewController!
    private let factory: AppFactory

    // MARK: - Init
    init(factory: AppFactory) {
        self.factory = factory
    }

    // MARK: - Lifecycle
    func start() {
        let viewModel = GuaXiangViewModel()
        
        viewModel.onInputSignal.throttle(0.5).emit(onNext: { [unowned self] _ in
            self.showInputViewController()
        }).disposed(by: viewModel.bag)
        
        viewController = factory.makeGuaXiangViewController(viewModel: viewModel)

        delegate?.didStart(self, viewController: viewController)
    }
}

// MARK: - Present Methods
private extension GuaXiangCoordinator {
    func showInputViewController() {
        let viewModel = InputViewModel()
        
        let inputVC = factory.makeInputViewController(viewModel: viewModel)
        inputVC.preferredContentSize = CGSize(width: 450, height: 450)
        inputVC.modalPresentationStyle = .formSheet
        
        viewModel.yaoTypeSignal.asObservable().elements()
            .do(onNext: { [unowned inputVC] _ in
                inputVC.dismiss(animated: true, completion: nil)
            }).map { yaoTypes in
                return LiuYaoGuaXiangBuilder().setLiuYao(yaoTypes).build()
            }.bind(to: viewController.viewModel.guaXiangRelay)
            .disposed(by: viewModel.bag)
    
        viewController.present(inputVC, animated: true, completion: nil)
    }
}
