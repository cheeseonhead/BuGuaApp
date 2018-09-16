//
//  GuaXiangInputCoordinatorModel.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation

class GuaXiangInputCoordinatorModel {

    // MARK: - Private properties
    private let builder = LiuYaoGuaXiangBuilder()

    func setLiuYao(_ liuYao: [YaoType]) {
        builder.setLiuYao(liuYao)
    }

    func setDateGanZhi(_ ganZhi: DateGanZhi) {
        builder.withDateGanZhi(ganZhi)
    }

    func liuYaoGuaXiang() -> LiuYaoGuaXiang {
        return builder.build()
    }
}

extension AppFactory {
    func makeGuaXiangInputCoordinatorModel() -> GuaXiangInputCoordinatorModel {
        return GuaXiangInputCoordinatorModel()
    }
}
