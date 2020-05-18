//
//  LiuShouController.swift
//  BuGuaKit
//
//  Created by Cheese Onhead on 2018-10-02.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public class LiuShouController {
    private let guaXiang: LiuYaoGuaXiang

    init(guaXiang: LiuYaoGuaXiang) {
        self.guaXiang = guaXiang
    }

    var liuShou: [LiuShou] {
        return liuShou(for: guaXiang.dateGanZhi.day.tianGan)
    }

    public func liuShou(at position: Int) -> LiuShou {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return liuShou[position - 1]
    }
}

private extension LiuShouController {
    func liuShou(for dayGan: TianGan) -> [LiuShou] {
        let fullRounds = LiuShou.allCases + LiuShou.allCases

        let start = startingIndex(for: dayGan)
        let finalRange = start ... (start + 5)

        return Array(fullRounds[finalRange])
    }

    func startingIndex(for dayGan: TianGan) -> Int {
        switch dayGan {
        case .jia, .yi: return 0
        case .bing, .ding: return 1
        case .wu: return 2
        case .ji: return 3
        case .geng, .xin: return 4
        case .ren, .gui: return 5
        }
    }
}
