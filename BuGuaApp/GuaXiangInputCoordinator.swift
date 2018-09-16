//
//  GuaXiangInputCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-17.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class GuaXiangInputCoordinator: Coordinator {

    // MARK: - Coordinator
    let bag = DisposeBag()
    var childCoordinators: [Coordinator] = []
    lazy private (set) var didStartSignal = didStartRelay.asSignal()

    // MARK: - Private Rx
    private var navigationController: UINavigationController!
    private let didStartRelay = PublishRelay<UIViewController>()
    private let factory: AppFactory

    // MARK: - Init
    init(factory: AppFactory) {
        self.factory = factory
    }

    // MARK: - Lifecycle
    func start() {
        let vm = factory.makeInputViewModel()
        let vc = factory.makeInputViewController(viewModel: vm)

        navigationController = UINavigationController(rootViewController: vc)

        didStartRelay.accept(navigationController)
    }
}

extension AppFactory {
    func makeGuaXiangInputCoordinator() -> GuaXiangInputCoordinator {
        return GuaXiangInputCoordinator(factory: self)
    }
}
