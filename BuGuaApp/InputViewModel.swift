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
import RxCocoa

enum Result<T> {
    case success(T), error(Error)
}

class InputViewModel {
    
    // MARK: - Public
    let bag = DisposeBag()
    
    // MARK: - Input Rx
    let guaIntRelay = PublishRelay<(String?, String?)>()
    let unstableYaoIntRelay = PublishRelay<[String?]>()

    // MARK: - Output Rx
    let resultRelay = PublishRelay<Result<LiuYaoGuaXiang>>()
    
    init() {
        let guaIntSubscription = guaIntRelay.flatMap { tup -> Observable<Event<(Int, Int)>> in
            let (innerStr, outerStr) = tup
            
            return Observable.just(()).map { try (Int(str: innerStr), Int(str: outerStr)) }.materialize()
        }.
//        let guaIntObservation = guaIntRelay.map { tup -> (Int, Int) in
//            let (innerStr, outerStr) = tup
//
//            return try (Int(str: innerStr), Int(str: outerStr))
//        }
        
        let unstableSubscription = unstableYaoIntRelay.flatMap { unstableStrs in
            return Observable.just(()).map { _ -> [String] in
                return unstableStrs.filter { $0 != nil }.map { $0! }
            }.map { try $0.map { try Int(str: $0) } }.materialize()
        }

        Observable.combineLatest(guaIntSubscription, unstableSubscription) { guaEvent, unstableEvent in
            
        }
        
//        Observable.combineLatest(guaIntObservation, unstableObservation) { guaInts, unstableInts -> Result<LiuYaoGuaXiang> in
//            let converter = IntegerGuaXiangConverter()
//            converter.innerGuaInt = guaInts.0
//            converter.outerGuaInt = guaInts.1
//            converter.unstableYaoInts = Set(unstableInts)
//
//            return try .success(converter.convert())
//        }.bind(to: resultRelay)
//        .disposed(by: bag)
//        inputRelay.map { stringInput -> Result<Input<Int>> in
//            do {
//                return .success(try stringInput.map(Int.init))
//            } catch {
//                return .error(error)
//            }
//        }.bind(to: resultRelay)
//        .disposed(by: bag)
    }
}

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

