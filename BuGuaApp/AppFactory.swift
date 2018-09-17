//
//  AppFactory.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

class AppFactory {

    let timeZone = TimeZone.autoupdatingCurrent

    func makeAppCoordinator(with window: UIWindow) -> AppCoordinator {
        return AppCoordinator(with: window, factory: self)
    }

    func makeGuaXiangCoordinator() -> GuaXiangCoordinator {
        return GuaXiangCoordinator(factory: self)
    }

    func makeGuaXiangViewController(viewModel: GuaXiangViewModel) -> GuaXiangViewController {
        return GuaXiangViewController(viewModel: viewModel)
    }
}
