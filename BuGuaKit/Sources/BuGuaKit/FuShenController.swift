//
//  FuShenController.swift
//  BuGuaKit
//
//  Created by Cheese Onhead on 2018-09-12.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public class FuShenController {
    private let guaXiang: LiuYaoGuaXiang

    // MARK: - Private

    private lazy var pureLiuShiSiGua: LiuShiSiGua = LiuShiSiGua(innerGua: guaXiang.originalGua.guaGong, outerGua: guaXiang.originalGua.guaGong)

    public init(guaXiang: LiuYaoGuaXiang) {
        self.guaXiang = guaXiang
    }

    public var fuShen: [LiuQin?] {
        let originalLiuQin = guaXiang.originalGua.liuQin
        let pure = pureLiuQin()

        return pure.map { originalLiuQin.contains($0) ? nil : $0 }
    }

    public func fuShen(at position: Int) -> LiuQin? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return fuShen[position - 1]
    }

    public var hiddenTianGan: [TianGan?] {
        let pureTianGan = pureLiuShiSiGua.tianGan

        return zip(fuShen, pureTianGan).map { shen, gan in
            shen != nil ? gan : nil
        }
    }

    public func hiddenTianGan(at position: Int) -> TianGan? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return hiddenTianGan[position - 1]
    }

    public var hiddenDiZhi: [DiZhi?] {
        let pureDiZhi = pureLiuShiSiGua.diZhi

        return zip(fuShen, pureDiZhi).map { shen, zhi in
            shen != nil ? zhi : nil
        }
    }

    public func hiddenDiZhi(at position: Int) -> DiZhi? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return hiddenDiZhi[position - 1]
    }

    public var hiddenGanZhi: [GanZhi?] {
        return zip(hiddenTianGan, hiddenDiZhi).map {
            guard let gan = $0.0, let zhi = $0.1 else { return nil }

            return GanZhi(gan, zhi)
        }
    }

    public func hiddenGanZhi(at position: Int) -> GanZhi? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return hiddenGanZhi[position - 1]
    }
}

private extension FuShenController {
    func pureLiuQin() -> [LiuQin] {
        return pureLiuShiSiGua.liuQin
    }
}
