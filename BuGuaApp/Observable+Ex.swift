//
//  Observable+Ex.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-06.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func unwrap<R>() -> Observable<R> where Element == Optional<R> {
        return filter { element in
            switch element {
            case .some: return true
            case .none: return false
            }
        }.map { $0! }
    }
}
