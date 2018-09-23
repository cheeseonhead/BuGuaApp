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
    static func alignHeader(_ headerView: HeaderLabelView, firstRow rowView: GuaXiangRow) {
        zip(headerView.headerLabels, rowView.viewStack).forEach { header, column in
            header.snp.makeConstraints({ make in
                make.centerX.equalTo(column)
            })
        }
    }
}
