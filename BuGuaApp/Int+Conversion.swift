//
//  Int+Conversion.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-06.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation

// MARK: - String

extension Int {
    enum Error: LocalizedError {
        case stringEmpty
        case notValidInteger(String)

        var errorDescription: String? {
            switch self {
            case .stringEmpty:
                return NSLocalizedString("空字串不是整數", comment: "")
            case let .notValidInteger(str):
                return String(format: NSLocalizedString("\"%@\"並非整數", comment: ""), str)
            }
        }
    }

    init?(str: String?) throws {
        guard let str = str, !str.isEmpty else {
            return nil
        }

        guard let integer = Int(str) else {
            throw Error.notValidInteger(str)
        }

        self = integer
    }
}

// MARK: - Int64

extension Int {
    var int64: Int64 {
        return Int64(self)
    }
}

extension Int64 {
    var int: Int {
        return Int(self)
    }
}
