//
//  GuaShenController.swift
//  BuGuaKit
//
//  Created by Cheese Onhead on 2018-10-02.
//  Copyright © 2018 cheeseonhead. All rights reserved.
//

import Foundation

public class GuaShenController {
    private let guaXiang: LiuYaoGuaXiang

    init(guaXiang: LiuYaoGuaXiang) {
        self.guaXiang = guaXiang
    }

    public var guaShen: [DiZhi?] {
        let shi = guaXiang.originalGua.shi

        let guaShenDiZhi = startZhi(for: guaXiang.yao(at: shi).originalYi).diZhi(after: shi - 1)

        return guaXiang.originalGua.ganZhi.map {
            if guaShenDiZhi == $0.diZhi {
                return $0.diZhi
            } else {
                return nil
            }
        }
    }

    public func guaShen(at position: Int) -> DiZhi? {
        assert(position >= 1 && position <= 6, "position \(position) out of range")

        return guaShen[position - 1]
    }
}

private extension GuaShenController {
    func startZhi(for liangYi: LiangYi) -> DiZhi {
        switch liangYi {
        case .yang: return .zi
        case .yin: return .wu
        }
    }
}
