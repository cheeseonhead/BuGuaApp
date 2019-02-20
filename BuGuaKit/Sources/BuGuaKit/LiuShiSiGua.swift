//
//  LiuShiSiGua.swift
//  BuGuaKit
//
//  Created by Cheese Onhead on 2018-07-22.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public struct LiuShiSiGua {
    enum Position {
        case inner, outer
    }

    public let innerGua: FuXiBaGua
    public let outerGua: FuXiBaGua

    public var character: String {
        return NSLocalizedString("liushisigua\(outerGua)\(innerGua)", tableName: nil, bundle: Bundle(identifier: "com.cheeseonhead.BuGuaKit")!, value: "", comment: "")
    }

    init(innerGua: FuXiBaGua, outerGua: FuXiBaGua) {
        self.innerGua = innerGua
        self.outerGua = outerGua
    }

    public var ying: Int {
        return (shi + 2) % 6 + 1
    }

    public var shi: Int {
        switch guaGongType {
        case 1: return 6
        case 2: return 1
        case 3: return 2
        case 4: return 3
        case 5: return 4
        case 6: return 5
        case 7: return 4
        case 8: return 3
        default:
            fatalError()
        }
    }

    public var guaGong: FuXiBaGua {
        switch guaGongType {
        case 1 ... 4: return outerGua
        case 5 ... 7: return innerGua.opposite
        case 8: return innerGua
        default:
            fatalError()
        }
    }

    public var ganZhi: [GanZhi] {
        return zip(tianGan, diZhi).map {
            GanZhi($0, $1)
        }
    }

    public func ganZhi(at position: Int) -> GanZhi {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return ganZhi[position - 1]
    }

    public var tianGan: [TianGan] {
        let innerZhi = Array(repeating: innerGua.tianGan(forPosition: .inner), count: 3)
        let outerZhi = Array(repeating: outerGua.tianGan(forPosition: .outer), count: 3)

        return innerZhi + outerZhi
    }

    public func tianGan(at position: Int) -> TianGan {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return tianGan[position - 1]
    }

    public var diZhi: [DiZhi] {
        let innerZhi = innerGua.diZhi(forPosition: .inner)
        let outerZhi = outerGua.diZhi(forPosition: .outer)

        return innerZhi + outerZhi
    }

    public func diZhi(at position: Int) -> DiZhi {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return diZhi[position - 1]
    }

    public var myXing: WuXing { return guaGong.wuXing }

    public var liuQin: [LiuQin] {
        return diZhi.map { (diZhi) -> LiuQin in
            LiuQin(from: myXing.relationShip(to: diZhi.wuXing))
        }
    }

    public func liuQin(at position: Int) -> LiuQin {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return liuQin[position - 1]
    }
}

private extension LiuShiSiGua {
    /// 回傳值是1-8，是按照一本書看來的，並沒有特別的意義
    var guaGongType: Int {
        let positions = differentPositions(aGua: innerGua, bGua: outerGua)

        if positions.count == 0 {
            return 1
        } else if positions.count == 3 {
            return 4
        } else if positions.count == 2 {
            let samePosition = FuXiBaGua.Position.allCases.filter { !positions.contains($0) }.first!

            switch samePosition {
            case .top:
                return 3
            case .middle:
                return 7
            case .bottom:
                return 5
            }
        } else if positions.count == 1 {
            let position = positions.first!

            switch position {
            case .bottom:
                return 2
            case .middle:
                return 8
            case .top:
                return 6
            }
        }

        assertionFailure("Shouldn't get here")
        return 0
    }

    func differentPositions(aGua: FuXiBaGua, bGua: FuXiBaGua) -> [FuXiBaGua.Position] {
        return FuXiBaGua.Position.allCases.filter { aGua.yao(at: $0) != bGua.yao(at: $0) }
    }
}
