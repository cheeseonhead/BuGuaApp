//
//  HorizontalDividersView.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-12.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

class HorizontalDividersView: UIView {
    
    // MARK: - Views
    var headers: (top: UIView, bottom: UIView)!
    var belowYao: [UIView]!
    
    // MARK: - Private constants
    private let heavyWeight = 2
    private let lightWeight = 1
    
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
private extension HorizontalDividersView {
    func setup() {
        headers = (makeDivider(weight: heavyWeight), makeDivider(weight: lightWeight))
        
        addSubview(headers.top)
        addSubview(headers.bottom)
        
        belowYao = (1...6).map { $0 == 3 ? heavyWeight : lightWeight }
            .map { makeDivider(weight: $0) }
            .map {
                addSubview($0)
                return $0
            }
    }
    
    func makeDivider(weight: Int) -> UIView {
        let divider = UIView(frame: .zero)
        divider.backgroundColor = .sunset
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(weight)
            make.leading.trailing.equalToSuperview()
        }
        
        return divider
    }
}
