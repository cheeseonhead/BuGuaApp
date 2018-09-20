//
//  ShallowThemeStore.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-19.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Named shallow because it doesn't actually access any stored data
class ShallowThemeStore: ThemeStoring {
    private (set) lazy var currentSeq = currentRelay.asDriver()
    
    let currentRelay: BehaviorRelay<Theme>
    
    init(initialTheme: Theme) {
        currentRelay = BehaviorRelay(value: initialTheme)
    }
}
