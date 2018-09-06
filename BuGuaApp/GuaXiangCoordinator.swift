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

    var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()

    private var viewController: GuaXiangViewController!
    private let factory: AppFactory

    init(factory: AppFactory) {
        self.factory = factory
    }

    func start() {
        let viewModel = GuaXiangViewModel()
        
        viewModel.onInputSignal.throttle(0.5).emit(onNext: { [unowned self] _ in
            self.showInputViewController()
        }).disposed(by: viewModel.bag)
        
        viewController = factory.makeGuaXiangViewController(viewModel: viewModel)

        delegate?.didStart(self, viewController: viewController)
    }
    
    func showInputViewController() {
        
    }
}
