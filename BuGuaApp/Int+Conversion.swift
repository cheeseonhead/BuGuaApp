//
//  Int+Conversion.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-06.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation

extension Int {
    enum Error: LocalizedError {
        case stringEmpty
        case notValidInteger
    }
    
    init(str: String?) throws {
        guard let str = str, !str.isEmpty else {
            throw Error.stringEmpty
        }
        
        guard let integer = Int(str) else {
            throw Error.notValidInteger
        }
        
        self = integer
    }
}
