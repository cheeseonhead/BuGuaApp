//
//  KongWangController.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-10-01.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public struct KongWang: Equatable {
    public let diZhis: [DiZhi]

    public var character: String {
        return diZhis[0].character + diZhis[1].character
    }

    init(diZhis: [DiZhi]) {
        precondition(diZhis.count == 2, "There can only ever be two di zhi in a kong wang.")

        self.diZhis = diZhis
    }
}

public class KongWangController {
    private let guaXiang: LiuYaoGuaXiang
    private let jiaXunKongWang: [DiZhi: [DiZhi]] = [
        .zi: [.xu, .hai],
        .yin: [.zi, .chou],
        .chen: [.yin, .mao],
        .wu: [.chen, .si],
        .shen: [.wu, .wei],
        .xu: [.shen, .you],
    ]

    init(guaXiang: LiuYaoGuaXiang) {
        self.guaXiang = guaXiang
    }

    public var kongWang: KongWang {
        let diZhis = allKongWangDiZhi(guaXiang)

        return KongWang(diZhis: diZhis)
    }
}

private extension KongWangController {
    func jiaXunDiZhi(_ ganZhi: GanZhi) -> DiZhi {
        let negativeDistanceToJia = ganZhi.tianGan.distanceTo(.jia)
        let sameXunDiZhi = ganZhi.diZhi.diZhi(after: negativeDistanceToJia)

        return sameXunDiZhi
    }

    func allKongWangDiZhi(_ guaXiang: LiuYaoGuaXiang) -> [DiZhi] {
        var kongWangDiZhis = [DiZhi]()

        let dayGanZhi = guaXiang.dateGanZhi.day
        kongWangDiZhis.append(contentsOf: jiaXunKongWang[jiaXunDiZhi(dayGanZhi)]!)

        return kongWangDiZhis
    }
}
