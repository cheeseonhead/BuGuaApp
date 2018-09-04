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

    private var viewController: UIViewController!
    private let factory: AppFactory

    init(factory: AppFactory) {
        self.factory = factory
    }

    func start() {
        viewController = factory.makeGuaXiangViewController()

        delegate?.didStart(self, viewController: viewController)
    }
}
