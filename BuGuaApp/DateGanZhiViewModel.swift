//
//  DateGanZhiViewModel.swift
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

class DateGanZhiViewModel {

    // MARK: - Output Rx
    let previewDriver: Driver<Event<String>>

    // MARK: - Input Rx
    let gregorianDateRelay = BehaviorRelay(value: GregorianDate.zero)

    // MARK: - Public
    let bag = DisposeBag()

    // MARK: - Private
    private let factory: AppFactory

    fileprivate init(factory: AppFactory) {
        self.factory = factory

        let calculator = factory.makeSolarTermCalculator()

        previewDriver = gregorianDateRelay.flatMap { gregorianDate in
            return Observable.just(()).map {
                let dateGanZhi = try calculator.ganZhi(for: gregorianDate)
                return dateGanZhi.year.character + dateGanZhi.month.character + dateGanZhi.day.character
            }.materialize()
        }.share().asDriver(onErrorDriveWith: .never())
    }
}

private extension DateGanZhiViewModel {

}

extension AppFactory {
    func makeDateGanZhiViewModel() -> DateGanZhiViewModel {
        return DateGanZhiViewModel(factory: self)
    }
}
