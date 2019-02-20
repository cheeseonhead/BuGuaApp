//
//  LiuYaoGuaXiang.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2018-08-25.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public class LiuYaoGuaXiangBuilder {
    private var liuYao: [YaoType]!
    private var dateGanZhi: DateGanZhi!
    private var timeDiZhi: DiZhi!

    public init(from guaXiang: LiuYaoGuaXiang) {
        liuYao = guaXiang.liuYao
        dateGanZhi = guaXiang.dateGanZhi
        timeDiZhi = guaXiang.timeDiZhi
    }

    public convenience init() {
        self.init(from: .default)
    }

    @discardableResult
    public func setLiuYao(_ liuYao: [YaoType]) -> LiuYaoGuaXiangBuilder {
        self.liuYao = liuYao
        return self
    }

    @discardableResult
    public func setDateGanZhi(_ ganZhi: DateGanZhi?) -> LiuYaoGuaXiangBuilder {
        dateGanZhi = ganZhi
        return self
    }

    @discardableResult
    public func setTimeDiZhi(_ diZhi: DiZhi) -> LiuYaoGuaXiangBuilder {
        timeDiZhi = diZhi
        return self
    }

    public func build() -> LiuYaoGuaXiang {
        return LiuYaoGuaXiang(liuYao: liuYao, dateGanZhi: dateGanZhi, timeDiZhi: timeDiZhi)
    }
}

public struct LiuYaoGuaXiang: Equatable {
    public static let `default` = LiuYaoGuaXiang(liuYao: [.youngYang, .youngYang, .youngYang, .youngYang, .youngYang, .youngYang],
                                                 dateGanZhi: .default, timeDiZhi: .zi)

    let liuYao: [YaoType]
    let innerYao: [YaoType]
    let outerYao: [YaoType]
    public let dateGanZhi: DateGanZhi
    public let timeDiZhi: DiZhi
    public var fuShenController: FuShenController { return FuShenController(guaXiang: self) }
    public var kongWangController: KongWangController { return KongWangController(guaXiang: self) }
    public var guaShenController: GuaShenController { return GuaShenController(guaXiang: self) }
    public var liuShouController: LiuShouController { return LiuShouController(guaXiang: self) }

    init(liuYao: [YaoType], dateGanZhi: DateGanZhi, timeDiZhi: DiZhi) {
        assert(liuYao.count == 6, "Cannot create GuaXiang without exactly 6 yao")

        self.liuYao = liuYao
        self.dateGanZhi = dateGanZhi
        self.timeDiZhi = timeDiZhi
        innerYao = Array(liuYao.prefix(3))
        outerYao = Array(liuYao.suffix(3))
    }

    public func yao(at position: Int) -> YaoType {
        assert(position >= 1 && position <= 6, "position out of range")

        return liuYao[position - 1]
    }

    public var originalGua: LiuShiSiGua {
        let innerGua = originalBaGua(from: innerYao)
        let outerGua = originalBaGua(from: outerYao)

        return LiuShiSiGua(innerGua: innerGua, outerGua: outerGua)
    }

    public var changedGua: LiuShiSiGua {
        let innerGua = changedBaGua(from: innerYao)
        let outerGua = changedBaGua(from: outerYao)

        return LiuShiSiGua(innerGua: innerGua, outerGua: outerGua)
    }

    public var changedTianGan: [TianGan?] {
        return zip(liuYao, changedGua.tianGan).map { yaoType, gan in
            if !yaoType.isStable {
                return gan
            } else {
                return nil
            }
        }
    }

    public func changedTianGan(at position: Int) -> TianGan? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return changedTianGan[position - 1]
    }

    public var changedDiZhi: [DiZhi?] {
        return zip(liuYao, changedGua.diZhi).map { yaoType, zhi in
            if !yaoType.isStable {
                return zhi
            } else {
                return nil
            }
        }
    }

    public var changedGanZhi: [GanZhi?] {
        return zip(changedTianGan, changedDiZhi).map {
            guard let gan = $0.0, let zhi = $0.1 else { return nil }

            return GanZhi(gan, zhi)
        }
    }

    public func changedGanZhi(at position: Int) -> GanZhi? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return changedGanZhi[position - 1]
    }

    public func changedDiZhi(at position: Int) -> DiZhi? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return changedDiZhi[position - 1]
    }

    public var changedLiuQin: [LiuQin?] {
        return zip(liuYao, changedGua.diZhi).map { yaoType, diZhi in
            if !yaoType.isStable {
                return LiuQin(from: originalGua.myXing.relationShip(to: diZhi.wuXing))
            } else {
                return nil
            }
        }
    }

    public func changedLiuQin(at position: Int) -> LiuQin? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return changedLiuQin[position - 1]
    }
}

private extension LiuYaoGuaXiang {
    func originalBaGua(from yao: [YaoType]) -> FuXiBaGua {
        assert(yao.count == 3, "Can only create it from 3 liangYi")

        return FuXiBaGua(top: yao[2].originalYi, middle: yao[1].originalYi, bottom: yao[0].originalYi)
    }

    func changedBaGua(from yao: [YaoType]) -> FuXiBaGua {
        assert(yao.count == 3, "Can only create it from 3 liangYi")

        return FuXiBaGua(top: yao[2].changedYi, middle: yao[1].changedYi, bottom: yao[0].changedYi)
    }
}
