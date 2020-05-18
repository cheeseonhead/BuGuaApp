//
//  GanZhi.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public struct GanZhi: Equatable {
    public let tianGan: TianGan
    public let diZhi: DiZhi

    public var character: String {
        return tianGan.character + diZhi.character
    }

    public init(_ gan: TianGan, _ zhi: DiZhi) {
        tianGan = gan
        diZhi = zhi
    }
}
