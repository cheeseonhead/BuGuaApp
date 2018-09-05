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

    // MARK: - Public Rx
    let guaXiangRelay = BehaviorRelay<LiuYaoGuaXiang>(value: .default)

}
