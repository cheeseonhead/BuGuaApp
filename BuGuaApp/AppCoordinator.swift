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

    let navigationController: UINavigationController
    private (set) var childCoordinators = [Coordinator]()

    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    deinit {
        print("deallocing \(self)")
    }

    func start() {
        
    }
}
