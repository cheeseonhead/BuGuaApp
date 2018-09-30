//
//  TimeGanZhiViewModel.swift
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

class TimeGanZhiViewModel {

    // MARK: - Output
    private (set) lazy var previewTextOutput = gregorianTimeInput.map(TimeGanZhiViewModel.preview)

    // MARK: - Input
    let gregorianTimeInput = BehaviorRelay(value: GregorianTime.zero)
    let finishInput = PublishRelay<()>()
}

// MARK: - Helper
private extension TimeGanZhiViewModel {
    static func preview(for gregorianTime: GregorianTime) -> String {
        let format = NSLocalizedString("%@時", comment: "time gan zhi")

        return String(format: format, gregorianTime.diZhi.character)
    }
}

extension AppFactory {
    func makeTimeGanZhiViewModel() -> TimeGanZhiViewModel {
        return TimeGanZhiViewModel()
    }
}
