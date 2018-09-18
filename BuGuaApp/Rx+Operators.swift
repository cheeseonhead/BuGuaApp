//
//  Rx+Operators.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-17.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import RxSwift
import RxSwiftExt
import Foundation

extension ObservableType where Self.E : EventConvertible {
    func elementsAndErrors() -> Observable<E> {
        return filter {
            switch $0.event {
            case .next, .error: return true
            default: return false
            }
        }
    }
}

extension ObservableType where Self.E : EventConvertible {
    func stringify(_ transform: @escaping (E.ElementType) -> String) -> Observable<String> {
        let result = filterMap { e -> FilterMap<String> in
            switch e.event {
            case .next(let value): return .map(transform(value))
            case .error(let error): return .map(error.localizedDescription)
            default: return .ignore
            }
        }
        
        return result
    }
}
