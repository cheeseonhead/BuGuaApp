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
    
    static func verticalAlignSixLabelView(_ sixLabelView: SixLabelView, shiYingYaoView: ShiYingYaoView) {
        zip(sixLabelView.labels, shiYingYaoView.yaoViews).forEach { label, yao in
            label.snp.makeConstraints { make in
                make.bottom.equalTo(yao)
            }
        }
        
        zip(sixLabelView.labels, shiYingYaoView.shiYingLabels).forEach { label, shiYingLabel in
            label.snp.makeConstraints { make in
                make.top.equalTo(shiYingLabel)
            }
        }
    }
    
    static func alignHeader(_ headerView: HeaderLabelView, columns: [UIView]) {
        zip(headerView.headerLabels, columns).forEach { header, column in
            header.snp.makeConstraints({ make in
                make.centerX.equalTo(column)
            })
        }
    }
    
    static func alignHorizontalDividers(_ dividerView: HorizontalDividersView, shiYingYaoView: ShiYingYaoView, headerView: HeaderLabelView) {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.headers.top.snp.bottom)
            make.bottom.equalTo(dividerView.headers.bottom.snp.top)
        }
        
        zip(shiYingYaoView.yaoViews.lazy.reversed(), dividerView.belowYao).forEach { yaoView, belowYao in
            belowYao.snp.makeConstraints({ make in
                make.top.equalTo(yaoView.snp.bottom)
            })
        }
        
        zip(shiYingYaoView.shiYingLabels.lazy.reversed().suffix(5), dividerView.belowYao.prefix(5)).forEach { shiYingLabel, aboveLabel in
            aboveLabel.snp.makeConstraints({ make in
                make.bottom.equalTo(shiYingLabel.snp.top)
            })
        }
    }
}
