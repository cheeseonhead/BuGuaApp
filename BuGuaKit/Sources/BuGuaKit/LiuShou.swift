//
//  LiuShou.swift
//  BuGuaKit
//
//  Created by Cheese Onhead on 2018-10-02.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public enum LiuShou: CaseIterable {
    case dragon, bird, hook, snake, tiger, tortoise

    public var character: String {
        return NSLocalizedString("liushou\(self)", tableName: nil, bundle: Bundle.module, value: "", comment: "")
    }
}
