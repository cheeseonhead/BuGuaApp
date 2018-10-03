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
import RxSwiftExt
import RxCocoa
import UIKit

class GuaXiangInputCoordinator: Coordinator {

    // MARK: - Coordinator
    let bag = DisposeBag()
    var childCoordinators: [Coordinator] = []
    lazy private (set) var didStartSignal = didStartRelay.asSignal()

    // MARK: - Ouput Rx
    let buGuaEntryRelay = PublishRelay<BuGuaEntry>()
    let cancelOutput = PublishRelay<()>()

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

        vm.yaoTypeSignal.asObservable().elements()
            .bind(onNext: { [unowned self] liuYao in
                self.model.setLiuYao(liuYao)
                self.showDateInput()
            }).disposed(by: vm.bag)

        vc.cancelOutput
            .bind(to: cancelOutput)
            .disposed(by: vc.bag)
        
        return vc
    }

    func showDateInput() {
        let vm = factory.makeDateGanZhiViewModel()
        let vc = factory.makeDateGanZhiViewController(viewModel: vm)

        let dateViewControllerOutput = Observable.zip(vm.finalDateGanZhiDriver, vm.finalGregorianDateDriver)

        dateViewControllerOutput.bind { [unowned self] (dateGanZhi, gregorianDate) in
            self.model.setDateGanZhi(dateGanZhi)
            self.model.setGregorianDate(gregorianDate)
            self.showTimeInput()
        }.disposed(by: vm.bag)

        navigationController.pushViewController(vc, animated: true)
    }

    func showTimeInput() {
        let vm = factory.makeTimeGanZhiViewModel()
        let vc = factory.makeTimeGanZhiViewController(viewModel: vm)

        vm.finalTimeOutput.bind { [unowned self] time in
            self.model.setGregorianTime(time)
            self.finishFlow()
        }.disposed(by: vm.bag)

        navigationController.pushViewController(vc, animated: true)
    }

    func finishFlow() {
        buGuaEntryRelay.accept(model.buGuaEntry())
    }
}

extension AppFactory {
    func makeGuaXiangInputCoordinator(model: GuaXiangInputCoordinatorModel) -> GuaXiangInputCoordinator {
        return GuaXiangInputCoordinator(factory: self, model: model)
    }
}
