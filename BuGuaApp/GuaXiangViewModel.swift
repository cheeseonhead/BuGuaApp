//
//  GuaXiangViewModel.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxSwift
import RxCocoa

class GuaXiangViewModel {

    // MARK: - Obervable Rx
    let bag = DisposeBag()
    lazy private (set) var onInputSignal = onInputRelay.asSignal()
    
    // MARK: - Observer Rx
    let onInputRelay = PublishRelay<()>()
    
    // MARK: - View Rx
    let guaXiangRelay = BehaviorRelay<LiuYaoGuaXiang>(value: .default)

}
