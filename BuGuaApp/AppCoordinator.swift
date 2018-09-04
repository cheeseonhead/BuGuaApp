//
//  AppCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    func start()
}

class AppCoordinator: Coordinator {

    private (set) var childCoordinators = [Coordinator]()

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
        } else {
//            window?.rootViewController = UITabBarController(nibName: nil, bundle: nil)
        }
    }
}
