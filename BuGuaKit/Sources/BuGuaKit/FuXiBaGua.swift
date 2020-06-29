//
//  FuXiBaGua.swift
//  BuGuaKit
//
//  Created by Cheese Onhead on 2018-07-22.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public enum FuXiBaGua: Int, CaseIterable {
    public enum Position: CaseIterable {
        case top, middle, bottom
    }

    case qian = 1
    case dui
    case li
    case zhen
    case xun
    case kan
    case gen
    case kun

    public init(top: LiangYi, middle: LiangYi, bottom: LiangYi) {
        self = FuXiBaGua.allCases.first(where: { (baGua) -> Bool in
            baGua.yao(at: .top) == top &&
                baGua.yao(at: .middle) == middle &&
                baGua.yao(at: .bottom) == bottom
        })!
    }

    public init(integer: Int) {
        let remainder = integer % 8

        switch remainder {
        case 0: self = .kun
        case 1 ... 7: self.init(rawValue: remainder)!
        default: fatalError()
        }
    }

    public var character: String {
        return NSLocalizedString("fuxibagua\(self)", tableName: nil, bundle: Bundle.module, value: "", comment: "")
    }

    public var opposite: FuXiBaGua {
        switch self {
        case .qian: return .kun
        case .dui: return .gen
        case .li: return .kan
        case .zhen: return .xun
        case .xun: return .zhen
        case .kan: return .li
        case .gen: return .dui
        case .kun: return .qian
        }
    }

    public var wuXing: WuXing {
        switch self {
        case .qian, .dui: return .gold
        case .li: return .fire
        case .zhen, .xun: return .wood
        case .kan: return .water
        case .gen, .kun: return .earth
        }
    }

    public var yinYang: LiangYi {
        switch self {
        case .qian, .zhen, .kan, .gen: return .yang
        case .dui, .li, .xun, .kun: return .yin
        }
    }

    public var allYaos: [LiangYi] {
        return [
            yao(at: .bottom),
            yao(at: .middle),
            yao(at: .top),
        ]
    }

    public func yao(at position: Position) -> LiangYi {
        let denominator: Double

        switch position {
        case .top:
            denominator = 1
        case .middle:
            denominator = 2
        case .bottom:
            denominator = 4
        }

        let value: Int = Int((Double(rawValue) / denominator).rounded(.up))
        let liangYiValue = value % 2

        switch liangYiValue {
        case 0:
            return .yin
        default:
            return .yang
        }
    }
}

// MARK: - 裝爻支

extension FuXiBaGua {
    func diZhi(forPosition position: LiuShiSiGua.Position) -> [DiZhi] {
        switch position {
        case .inner: return Array(diZhiOrder.prefix(3))
        case .outer: return Array(diZhiOrder.suffix(3))
        }
    }

    func tianGan(forPosition position: LiuShiSiGua.Position) -> TianGan {
        switch position {
        case .inner: return tianGanPosition[0]
        case .outer: return tianGanPosition[1]
        }
    }

    private var tianGanPosition: [TianGan] {
        switch self {
        case .qian: return [.jia, .ren]
        case .kan: return [.wu, .wu]
        case .gen: return [.bing, .bing]
        case .zhen: return [.geng, .geng]
        case .xun: return [.xin, .xin]
        case .li: return [.ji, .ji]
        case .kun: return [.yi, .gui]
        case .dui: return [.ding, .ding]
        }
    }

    private var diZhiOrder: [DiZhi] {
        switch self {
        case .qian, .zhen: return [.zi, .yin, .chen, .wu, .shen, .xu]
        case .kan: return [.yin, .chen, .wu, .shen, .xu, .zi]
        case .gen: return [.chen, .wu, .shen, .xu, .zi, .yin]
        case .dui: return [.si, .mao, .chou, .hai, .you, .wei]
        case .li: return [.mao, .chou, .hai, .you, .wei, .si]
        case .xun: return [.chou, .hai, .you, .wei, .si, .mao]
        case .kun: return [.wei, .si, .mao, .chou, .hai, .you]
        }
    }
}
