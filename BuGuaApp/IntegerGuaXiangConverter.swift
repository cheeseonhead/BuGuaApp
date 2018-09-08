//
//  IntegerGuaXiangConverter.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-06.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation

class IntegerGuaXiangConverter {
    
    enum Error: LocalizedError {
        case missingInnerGuaInt
        case missingOuterGuaInt
        
        var errorDescription: String? {
            switch self {
            case .missingInnerGuaInt: return NSLocalizedString("內掛數不可留空", comment: "")
            case .missingOuterGuaInt: return NSLocalizedString("外掛數不可留空", comment: "")
            }
        }
    }
    
    var innerGuaInt: Int?
    var outerGuaInt: Int?
    var unstableYaoInts = Set<Int>()
    
    func convert() throws -> LiuYaoGuaXiang {
        let (inner, outer) = try validate()
        
        let pureYaos = getPureYao(from: inner, outer: outer)
        
        let unstableIndexes = unstableYaoInts.map { ($0 - 1) % 6 }
        
        let yaoTypes = pureYaos.enumerated().map { tup -> YaoType in
            let (offset, yaoType) = tup
            if unstableIndexes.contains(offset) {
                return yaoType.toggledStability
            } else {
                return yaoType
            }
        }
        
        return LiuYaoGuaXiang(liuYao: yaoTypes)
    }
}

// MARK: - Helper
private extension IntegerGuaXiangConverter {
    func validate() throws -> (innerInt: Int, outerInt: Int) {
        guard let inner = innerGuaInt else {
            throw Error.missingInnerGuaInt
        }
        
        guard let outer = outerGuaInt else {
            throw Error.missingOuterGuaInt
        }
        
        return (inner, outer)
    }
    
    func getPureYao(from inner: Int, outer: Int) -> [YaoType] {
        let innerYaos = FuXiBaGua(integer: inner).allYaos
        let outerYaos = FuXiBaGua(integer: outer).allYaos
        
        return (innerYaos + outerYaos).map { $0.yaoType }
    }
}
