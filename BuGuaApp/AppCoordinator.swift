//
//  AppCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var didStartSignal: Signal<UIViewController> { get }
    var bag: DisposeBag { get }

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

class AppCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    lazy private (set) var didStartSignal = didStartRelay.asSignal()
    let bag = DisposeBag()

    // MARK: - Private Rx
    private let didStartRelay = PublishRelay<UIViewController>()

    private let testing = false

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
            didStartRelay.accept(window!.rootViewController!)
        } else {
            let guaXiangCoordinator = factory.makeGuaXiangCoordinator()

            guaXiangCoordinator.didStartSignal
                .do(onNext: { [unowned self] vc in
                    self.window?.rootViewController = vc
                }).emit(to: didStartRelay)
                .disposed(by: guaXiangCoordinator.bag)

            addChildCoordinator(guaXiangCoordinator)
            guaXiangCoordinator.start()
        }
    }
}
