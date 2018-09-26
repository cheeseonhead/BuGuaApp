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
    let entryRelay = PublishRelay<BuGuaEntry>()
}

extension AppFactory {
    func makeBuGuaEntryViewModel() -> BuGuaEntryViewModel {
        return BuGuaEntryViewModel()
    }
}
