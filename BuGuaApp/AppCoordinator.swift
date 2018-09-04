//
//  AppCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorDelegate: class {
    func didStart(_ coordinator: Coordinator, viewController: UIViewController)
}

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var delegate: CoordinatorDelegate? { get set }

    func start()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

class AppCoordinator: Coordinator, CoordinatorDelegate {

    var childCoordinators = [Coordinator]()
    var delegate: CoordinatorDelegate?

    private let testing = true

    private weak var window: UIWindow?
    private let factory: AppFactory

    init(with window: UIWindow, factory: AppFactory) {
        self.window = window
        self.factory = factory
    }

    deinit {
        print("deallocing \(self)")
    }

    func start() {
        if testing {
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
            delegate?.didStart(self, viewController: window!.rootViewController!)
        } else {
            let guaXiangCoordinator = factory.makeGuaXiangCoordinator()
            guaXiangCoordinator.delegate = self
            guaXiangCoordinator.start()
            addChildCoordinator(guaXiangCoordinator)
        }
    }

    func didStart(_ coordinator: Coordinator, viewController: UIViewController) {
        window?.rootViewController = viewController
    }
}
