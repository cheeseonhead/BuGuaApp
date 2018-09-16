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

    // MARK: - Lifecycle
    func start() {
        let vc = UIViewController(nibName: nil, bundle: nil)

        vc.view.backgroundColor = .red
        vc.preferredContentSize = CGSize(width: 200, height: 200)

        vc.preferredContentSizeDidChange(forChildContentContainer: vc)

        navigationController = UINavigationController(rootViewController: vc)

        didStartRelay.accept(navigationController)
    }
}
