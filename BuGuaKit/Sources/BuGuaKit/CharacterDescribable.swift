//
//  CharacterDescribable.swift
//  BuGuaKit
//
//  Created by Jeffrey Wu on 2019-02-27.
//  Copyright © 2019 cheeseonhead. All rights reserved.
//

import Foundation

public protocol CharacterDescribable {
    var character: String { get }
}

extension FuXiBaGua: CharacterDescribable {}

extension WuXing: CharacterDescribable {}

extension DiZhi: CharacterDescribable {}

extension LiuQin: CharacterDescribable {}

extension TianGan: CharacterDescribable {}

extension LiuShou: CharacterDescribable {}

extension GanZhi: CharacterDescribable {}

extension LiuShiSiGua: CharacterDescribable {}
