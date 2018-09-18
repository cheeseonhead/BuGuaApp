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
    private(set) lazy var previewDriver = dateGanZhiEventDriver.map { [unowned self] event in
        event.map { self.formatDateGanZhi($0) }
    }
    private (set) lazy var finalDateGanZhiDriver = finishRelay.withLatestFrom(dateGanZhiEventDriver)

    // MARK: - Input Rx
    let gregorianDateRelay = BehaviorRelay(value: GregorianDate.zero)
    let finishRelay = PublishRelay<()>()

    // MARK: - Public
    let bag = DisposeBag()

    // MARK: - Private
    private let factory: AppFactory
    private lazy var solarTermCalculator = factory.makeSolarTermCalculator()
    private lazy var dateGanZhiEventDriver: Driver<Event<DateGanZhi>> = {
        gregorianDateRelay.flatMap { [unowned self] gregorianDate in
            return Observable.just(()).map {
                try self.solarTermCalculator.ganZhi(for: gregorianDate)
                }.materialize()
            }.share()
            .elementsAndErrors()
            .asDriver(onErrorDriveWith: .never())
    }()

    fileprivate init(factory: AppFactory) {
        self.factory = factory
    }
}

private extension DateGanZhiViewModel {
    func previewString(for gregorianDate: GregorianDate) throws -> String {
        let dateGanZhi = try solarTermCalculator.ganZhi(for: gregorianDate)
        return formatDateGanZhi(dateGanZhi)
    }

    func formatDateGanZhi(_ dateGanZhi: DateGanZhi) -> String {
        let format = NSLocalizedString("%@年 %@月 %@日", comment: "")

        return String(format: format, dateGanZhi.year.character, dateGanZhi.month.character, dateGanZhi.day.character)
    }
}

extension AppFactory {
    func makeDateGanZhiViewModel() -> DateGanZhiViewModel {
        return DateGanZhiViewModel(factory: self)
    }
}

