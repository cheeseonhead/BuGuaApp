//
//  InputViewModel.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Result<T> {
    case success(T), error(Error)
}

class InputViewModel {
    
    struct Input<T> {
        let field1: T
        let field2: T
        let field3: T
        
        func map<R>(_ transform: (T) throws -> R) throws -> Input<R> {
            return try Input<R>(field1: transform(field1),
                            field2: transform(field2),
                            field3: transform(field3))
        }
    }
    
    // MARK: - Public
    let bag = DisposeBag()
    
    // MARK: - Input Rx
    let inputRelay = PublishRelay<Input<String?>>()

    // MARK: - Output Rx
    let resultRelay = PublishRelay<Result<Input<Int>>>()
    
    init() {
        inputRelay.map { stringInput -> Result<Input<Int>> in
            do {
                return .success(try stringInput.map(InputViewModel.getInt))
            } catch {
                return .error(error)
            }
        }.bind(to: resultRelay)
        .disposed(by: bag)
    }
    
    static func getInt(from str: String?) throws -> Int {
        
        guard let str = str, !str.isEmpty else {
            throw "空字串並非整數"
        }
        
        guard let result = Int(str) else {
            throw "\"\(str)\" 不是一個整數"
        }
        return result
    }
}

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

