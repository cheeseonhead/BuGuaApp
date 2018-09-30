//
//  TimeInputViewModel.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class TimeInputViewModel {
    // MARK: - Input Rx
    let dateRelay = BehaviorRelay<Date>(value: Date())

    // MARK: - Output Rx
    lazy private (set) var gregorianTimeRelay = dateRelay.asDriver().map { [unowned self] date in
        return GregorianTime(timeZone: self.timeZoneGetter(), date: date)
    }

    // MARK: - Private
    private let timeZoneGetter: () -> TimeZone

    init(timeZoneGetter: @escaping () -> TimeZone) {
        self.timeZoneGetter = timeZoneGetter
    }
}

extension AppFactory {
    func makeTimeInputViewModel() -> TimeInputViewModel {
        return TimeInputViewModel(timeZoneGetter: { self.timeZone })
    }
}
