//
//  GuaXiangCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
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
extension GuaXiangCoordinator {
    func showInputViewController() {
        let viewModel = InputViewModel()
        
        let inputVC = factory.makeInputViewController(viewModel: viewModel)
        inputVC.preferredContentSize = CGSize(width: 450, height: 450)
        inputVC.modalPresentationStyle = .formSheet
        
        viewController.present(inputVC, animated: true, completion: nil)
    }
}
