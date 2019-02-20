//
//  DateGanZhi.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public struct DateGanZhi: Equatable {
    public let year: GanZhi
    public let month: GanZhi
    public let day: GanZhi

    public static let `default` = DateGanZhi(year: GanZhi(.jia, .zi),
                                             month: GanZhi(.jia, .zi),
                                             day: GanZhi(.jia, .zi))
}
