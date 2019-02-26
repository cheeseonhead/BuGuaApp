//
//  Array+Convert.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-11.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func toSet() -> Set<Element> {
        return Set(self)
    }
}
