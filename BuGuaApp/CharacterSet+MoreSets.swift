//
//  CharacterSet+MoreSets.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-05.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation

extension CharacterSet {
    static var positiveWholeNumbers: CharacterSet {
        return decimalDigits.subtracting(CharacterSet(charactersIn: ".-"))
    }
}
