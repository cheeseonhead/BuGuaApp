//
//  GuaXiangCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import SnapKit
import UIKit

class BuGuaEntryCoordinator: Coordinator {
    // MARK: - Coordinator

    var childCoordinators = [Coordinator]()
    private(set) lazy var didStartSignal = didStartRelay.asSignal()
    var bag = DisposeBag()

    // MARK: - Private properties

    private var navigationController: UINavigationController!
    private var viewController: BuGuaEntryViewController!
    private let factory: AppFactory
    private let didStartRelay = PublishRelay<UIViewController>()

    // MARK: - Init

    init(factory: AppFactory) {
        self.factory = factory
    }

    // MARK: - Lifecycle

    func start() {
        let viewModel = factory.makeBuGuaEntryViewModel()
        viewController = factory.makeBuGuaEntryViewController(viewModel: viewModel)

        viewController.inputButton.rx.tap.bind(onNext: { [unowned self] _ in
            self.showGuaXiangInputFlow()
        }).disposed(by: viewController.bag)

        navigationController = UINavigationController(rootViewController: viewController)

        didStartRelay.accept(navigationController)
    }
}

// MARK: - Present Methods

private extension BuGuaEntryCoordinator {
    func showGuaXiangInputFlow() {
        let modalViewController = UIViewController(nibName: nil, bundle: nil)
        modalViewController.preferredContentSize = CGSize(width: 450, height: 450)
        modalViewController.modalPresentationStyle = .formSheet

        let model = factory.makeGuaXiangInputCoordinatorModel()

        let inputCoordinator = factory.makeGuaXiangInputCoordinator(model: model)

        inputCoordinator.didStartSignal.emit(onNext: { [unowned self, modalViewController] vc in
            self.viewController.present(modalViewController, animated: true, completion: nil)
            modalViewController.add(vc)
        }).disposed(by: inputCoordinator.bag)

        inputCoordinator.cancelOutput.bind { [unowned modalViewController] _ in
            modalViewController.dismiss(animated: true, completion: nil)
        }.disposed(by: inputCoordinator.bag)

        inputCoordinator.buGuaEntryRelay.take(1)
            .do(onNext: { [unowned modalViewController] _ in
                modalViewController.dismiss(animated: true, completion: nil)
            }).map { [unowned self] entry in
                self.factory.makeBuGuaEntryMediator(entry)
            }.bind(to: viewController.viewModel.entryMediatorRelay)
            .disposed(by: inputCoordinator.bag)

        addChildCoordinator(inputCoordinator)
        inputCoordinator.start()
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)

        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
