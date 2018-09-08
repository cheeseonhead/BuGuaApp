//
//  GuaXiangViewLayout.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-08.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class GuaXiangViewLayout {
    static func layoutGuaGong(_ label: UILabel, topLiuQin: UILabel) {
        label.snp.makeConstraints { make in
            make.trailing.equalTo(topLiuQin.snp.leading).offset(-24)
            make.centerY.equalTo(topLiuQin.snp.centerY)
        }
    }
}
