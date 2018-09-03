//
//  String+Vertical.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-03.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation

extension String {
    var vertical: String {
        forEach { c in
            print(c)
        }
        return lazy.map { String($0) }.joined(separator: "\n")
    }
}
