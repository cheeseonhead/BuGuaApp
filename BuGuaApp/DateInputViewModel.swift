//
//  DateInputViewModel.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class DateInputViewModel {

    // MARK: - Input Rx
    let dateRelay = BehaviorRelay<Date>(value: Date())

    // MARK: - Output Rx
    lazy private (set) var gregorianDateDriver = dateRelay.asDriver().map { [unowned self] date in
        return GregorianDate(timeZone: self.timeZoneGetter(), date: date)
    }

    // MARK: - Private
    private let timeZoneGetter: () -> TimeZone

    init(timeZoneGetter: @escaping () -> TimeZone) {
        self.timeZoneGetter = timeZoneGetter
    }
}

extension AppFactory {
    func makeDateInputViewModel() -> DateInputViewModel {
        return DateInputViewModel(timeZoneGetter: { [unowned self] in self.timeZone })
    }
}
