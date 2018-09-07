//
//  GuaXiangCoordinator.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxSwift
import UIKit

class GuaXiangCoordinator: Coordinator {

    // MARK: - Coordinator
    var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()

    // MARK: - Private properties
    private var viewController: GuaXiangViewController!
    private let factory: AppFactory

    // MARK: - Init
    init(factory: AppFactory) {
        self.factory = factory
    }

    // MARK: - Lifecycle
    func start() {
        let viewModel = GuaXiangViewModel()
        
        viewModel.onInputSignal.throttle(0.5).emit(onNext: { [unowned self] _ in
            self.showInputViewController()
        }).disposed(by: viewModel.bag)
        
        viewController = factory.makeGuaXiangViewController(viewModel: viewModel)

        delegate?.didStart(self, viewController: viewController)
    }
}

// MARK: - Present Methods
private extension GuaXiangCoordinator {
    func showInputViewController() {
        let viewModel = InputViewModel()
        
        let inputVC = factory.makeInputViewController(viewModel: viewModel)
        inputVC.preferredContentSize = CGSize(width: 450, height: 450)
        inputVC.modalPresentationStyle = .formSheet
        
        viewModel.resultRelay
            .map { result -> InputViewModel.Input<Int>? in
                switch result {
                case .success(let value): return value
                case .error: return nil
                }
            }.unwrap().unwrap().map { [unowned inputVC] input in
                inputVC.dismiss(animated: true, completion: nil)
                return GuaXiangCoordinator.convertedGuaXiang(from: input.field1, input.field2, input.field3)
            }.bind(to: viewController.viewModel.guaXiangRelay)
            .disposed(by: viewModel.bag)
        
        viewController.present(inputVC, animated: true, completion: nil)
    }
}

// MARK: - Helpers
private extension GuaXiangCoordinator {
    static func convertedGuaXiang(from number1: Int, _ number2: Int, _ number3: Int) -> LiuYaoGuaXiang {
        let innerYaos = FuXiBaGua(integer: number1).allYaos
        let outerYaos = FuXiBaGua(integer: number2).allYaos
        
        let unstableIndex = (number3 - 1) % 6
        
        let yaoTypes = [innerYaos, outerYaos].flatMap { $0 }.enumerated().map { tup -> YaoType in
            let (offset, liangYi) = tup
            if offset == unstableIndex {
                return liangYi.yaoType.toggledStability
            } else {
                return liangYi.yaoType
            }
        }
        
        return LiuYaoGuaXiang(liuYao: yaoTypes)
    }
}

