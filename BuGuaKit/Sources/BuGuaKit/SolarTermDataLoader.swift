//
//  SolarTermDataLoader.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

class SolarTermDataLoader {
    let url: URL

    init() {
        url = Bundle(for: SolarTermCalculator.self).url(forResource: "SolarTermDateComponents", withExtension: "plist")!
    }

    func loadData() throws -> [[Int]] {
        let dateData = try Data(contentsOf: url)
        let array = try PropertyListSerialization.propertyList(from: dateData, options: .mutableContainers, format: nil) as! [[Int]]

        return array
    }
}
