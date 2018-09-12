//
//  InputViewModel.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa

class InputViewModel {
    
    // MARK: - Public
    let bag = DisposeBag()
    
    // MARK: - Input Rx
    let guaStrRelay = PublishRelay<(String?, String?)>()
    let unstableYaoStrRelay = PublishRelay<[String?]>()


    // MARK: - Output Rx
    let guaXiangSignal: Signal<Event<LiuYaoGuaXiang>>
    
    init() {
        
        guaXiangSignal = PublishRelay.combineLatest(guaStrRelay, unstableYaoStrRelay).flatMap { guaStrs, unstableStrs in
            return Observable.just(()).map {
                try InputViewModel.convertGuaXiang(guaStrs: guaStrs, unstableStrs: unstableStrs)
            }.materialize()
        }.share().asSignal(onErrorSignalWith: .never())
    }
}

private extension InputViewModel {
    static func convertGuaXiang(guaStrs: (String?, String?), unstableStrs: [String?]) throws -> LiuYaoGuaXiang {
        let converter = IntegerGuaXiangConverter()
        converter.innerGuaInt = try Int(str: guaStrs.0)
        converter.outerGuaInt = try Int(str: guaStrs.1)
        converter.unstableYaoInts = try unstableStrs.unwrap().filter { !$0.isEmpty }.map(Int.init).toSet()
        
        return try converter.convert()
    }
}
