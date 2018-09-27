//
//  AppCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    private(set) lazy var didStartSignal = didStartRelay.asSignal()
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
