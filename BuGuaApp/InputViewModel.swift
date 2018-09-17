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
    let yaoTypeSignal: Signal<Event<[YaoType]>>

    // MARK: - Private properties
    private let factory: AppFactory
    
    init(factory: AppFactory) {
        self.factory = factory
        
        yaoTypeSignal = PublishRelay.zip(guaStrRelay, unstableYaoStrRelay).flatMap { guaStrs, unstableStrs in
            return Observable.just(()).map {
                try InputViewModel.convertYaoTypes(guaStrs: guaStrs, unstableStrs: unstableStrs)
            }.materialize()
        }.share().asSignal(onErrorSignalWith: .never())
    }
}

private extension InputViewModel {
    static func convertYaoTypes(guaStrs: (String?, String?), unstableStrs: [String?]) throws -> [YaoType] {
        let converter = IntegerLiuYaoConverter()
        converter.innerGuaInt = try Int(str: guaStrs.0)
        converter.outerGuaInt = try Int(str: guaStrs.1)
        converter.unstableYaoInts = try unstableStrs.map(Int.init).unwrap().toSet()
        
        return try converter.convert()
    }
}

extension AppFactory {
    func makeInputViewModel() -> InputViewModel {
        return InputViewModel(factory: self)
    }
}
