//
//  SixLabelView.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-11.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class SixLabelView: UIView {
    
    // MARK: - Views
    var labels: [UILabel]!
    
    // MARK: - Input Rx
    let bag = DisposeBag()
    let dataRelay = PublishRelay<[String]>()
    
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
private extension SixLabelView {
    func setup() {
        setupLabels()
        constraints()
        styling()
    }
    
    func setupLabels() {
        labels = (1...6).map { makeDiZhiLabel(at: $0) }.map { label in
            addSubview(label)
            return label
        }
    }
    
    func makeDiZhiLabel(at position: Int) -> UILabel {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.text = "-"
        
        dataRelay.map { $0[position - 1] }
            .bind { str in
                label.text = str
            }.disposed(by: bag)
        
        return label
    }
    
    func constraints() {
        labels.last!.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        labels.first!.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        labels.forEach {
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(safeAreaLayoutGuide)
            }
        }
    }
    
    func styling() {
        labels.forEach { label in
            label.font = .headline
            label.textColor = .spaceGrey
        }
    }
}
