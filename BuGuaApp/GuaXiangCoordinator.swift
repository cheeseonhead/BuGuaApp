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

class GuaXiangCoordinator: Coordinator {

    // MARK: - Coordinator
    var childCoordinators = [Coordinator]()
    lazy private (set) var didStartSignal = didStartRelay.asSignal()
    var bag = DisposeBag()

    // MARK: - Private properties
    private var viewController: GuaXiangViewController!
    private let factory: AppFactory
    private let didStartRelay = PublishRelay<UIViewController>()

    // MARK: - Init
    init(factory: AppFactory) {
        self.factory = factory
    }

    // MARK: - Lifecycle
    func start() {
        let viewModel = GuaXiangViewModel()
        
        viewModel.onInputSignal.throttle(0.5).emit(onNext: { [unowned self] _ in
            self.showGuaXiangInputFlow()
        }).disposed(by: viewModel.bag)
        
        viewController = factory.makeGuaXiangViewController(viewModel: viewModel)

        didStartRelay.accept(viewController)
    }
}

// MARK: - Present Methods
private extension GuaXiangCoordinator {

    func showGuaXiangInputFlow() {
        let modalViewController = UIViewController(nibName: nil, bundle: nil)
        modalViewController.preferredContentSize = CGSize(width: 450, height: 450)
        modalViewController.modalPresentationStyle = .formSheet
        modalViewController.view.tintColor = viewController.view.tintColor

        let model = factory.makeGuaXiangInputCoordinatorModel()

        let inputCoordinator = factory.makeGuaXiangInputCoordinator(model: model)
        inputCoordinator.didStartSignal.emit(onNext: { [unowned self, modalViewController] vc in
            self.viewController.present(modalViewController, animated: true, completion: nil)
            modalViewController.add(vc)
        }).disposed(by: inputCoordinator.bag)

        inputCoordinator.guaXiangRelay.take(1)
            .do(onNext: { [unowned modalViewController] _ in
                modalViewController.dismiss(animated: true, completion: nil)
            }).bind(to: viewController.viewModel.guaXiangRelay)
            .disposed(by: inputCoordinator.bag)

        addChildCoordinator(inputCoordinator)
        inputCoordinator.start()
    }

    func showInputViewController() {
        let viewModel = factory.makeInputViewModel()
        
        let inputVC = factory.makeInputViewController(viewModel: viewModel)
        inputVC.preferredContentSize = CGSize(width: 450, height: 450)
        inputVC.modalPresentationStyle = .formSheet
        
        viewModel.yaoTypeSignal.asObservable().elements()
            .do(onNext: { [unowned inputVC] _ in
                inputVC.dismiss(animated: true, completion: nil)
            }).map { yaoTypes in
                return LiuYaoGuaXiangBuilder().setLiuYao(yaoTypes).build()
            }.bind(to: viewController.viewModel.guaXiangRelay)
            .disposed(by: viewModel.bag)
    
        viewController.present(inputVC, animated: true, completion: nil)
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)

        child.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
