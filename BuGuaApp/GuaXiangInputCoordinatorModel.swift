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
    private let guaXiangBuilder = LiuYaoGuaXiangBuilder()
    private let buGuaEntryBuilder = BuGuaEntryBuilder()

    func setLiuYao(_ liuYao: [YaoType]) {
        guaXiangBuilder.setLiuYao(liuYao)
    }

    func setDateGanZhi(_ ganZhi: DateGanZhi) {
        guaXiangBuilder.withDateGanZhi(ganZhi)
    }

    func setGregorianDate(_ date: GregorianDate) {
        buGuaEntryBuilder.setDate(date)
    }

    func buGuaEntry() -> BuGuaEntry {

        return buGuaEntryBuilder.setGuaXiang(guaXiangBuilder.build())
            .build()
    }
}

extension AppFactory {
    func makeGuaXiangInputCoordinatorModel() -> GuaXiangInputCoordinatorModel {
        return GuaXiangInputCoordinatorModel()
    }
}
