//
//  BuGuaEntryViewModel.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-24.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxSwift
import RxCocoa

class BuGuaEntryViewModel {
    // MARK: - Relays
    let bag = DisposeBag()
    let entryMediatorRelay = PublishRelay<BuGuaEntryMediator>()
}

extension AppFactory {
    func makeBuGuaEntryViewModel() -> BuGuaEntryViewModel {
        return BuGuaEntryViewModel()
    }
}
