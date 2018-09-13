//
//  HeaderLabelView.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-11.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

class HeaderLabelView: UIView {
    
    // MARK: - Views
    var headerLabels: [UILabel]!
    
    // MARK: - Private Constants
    private let headerText = ["六親", "爻象世應", "干支"]
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}

// MARK: - Setup
private extension HeaderLabelView {
    func setup() {
        headerLabels = headerText.map { makeHeaderLabel($0) }.map {
            addSubview($0)
            return $0
        }
        
        headerLabels.first!.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        headerLabels.last!.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        headerLabels.forEach {
            $0.snp.makeConstraints({ make in
                make.centerY.equalTo(safeAreaLayoutGuide)
            })
        }
    }
    
    func makeHeaderLabel(_ text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = text
        label.font = .body2
        label.textColor = .spaceGrey
        
        return label
    }
}
