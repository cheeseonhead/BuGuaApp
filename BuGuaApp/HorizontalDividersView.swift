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
    
    // MARK: - Private properties
    private var dividers: [UIView]!

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func tintColorDidChange() {
        dividers.forEach { $0.subviews[0].backgroundColor = tintColor }
    }
}

// MARK: - Setup
private extension HorizontalDividersView {
    func setup() {
        headers = (makeWrapper(weight: heavyWeight), makeWrapper(weight: lightWeight))
        
        addSubview(headers.top)
        addSubview(headers.bottom)
        
        belowYao = (1...6).map { $0 == 3 || $0 == 6 ? heavyWeight : lightWeight }
            .map { makeWrapper(weight: $0) }
            .map {
                addSubview($0)
                return $0
        }
        
        headers.top.snp.makeConstraints { $0.top.equalToSuperview() }
        belowYao.last!.snp.makeConstraints { $0.bottom.equalToSuperview() }
        
        dividers = [headers.top, headers.bottom] + belowYao
        
        dividers.forEach { view in
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
            }
        }
    }
    
    func makeWrapper(weight: Int) -> UIView {
        let divider = makeDivider(weight: weight)
        let wrapper = UIView(frame: .zero)
        
        wrapper.addSubview(divider)
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().priority(.low)
        }
        
        return wrapper
    }
    
    func makeDivider(weight: Int) -> UIView {
        let divider = UIView(frame: .zero)
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(weight)
        }
        
        return divider
    }
}
