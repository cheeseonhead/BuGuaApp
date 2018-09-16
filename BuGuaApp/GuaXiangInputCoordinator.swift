//
//  GuaXiangInputCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-17.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
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
    private let model: GuaXiangInputCoordinatorModel

    // MARK: - Init
    init(factory: AppFactory, model: GuaXiangInputCoordinatorModel) {
        self.factory = factory
        self.model = model
    }

    // MARK: - Lifecycle
    func start() {
        let vc = getInputViewController()

        navigationController = UINavigationController(rootViewController: vc)

        didStartRelay.accept(navigationController)
    }
}

private extension GuaXiangInputCoordinator {
    func getInputViewController() -> InputViewController {
        let vm = factory.makeInputViewModel()
        let vc = factory.makeInputViewController(viewModel: vm)

//        vm.yaoTypeSignal.emit

        return vc
    }
}

extension AppFactory {
    func makeGuaXiangInputCoordinator(model: GuaXiangInputCoordinatorModel) -> GuaXiangInputCoordinator {
        return GuaXiangInputCoordinator(factory: self, model: model)
    }
}
