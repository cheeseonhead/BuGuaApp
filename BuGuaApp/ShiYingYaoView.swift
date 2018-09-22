//
//  ShiYingYaoView.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-11.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxSwift
import RxCocoa
import UIKit

class ShiYingYaoView: UIView {
    // MARK: - Views
    var yaoViews: [YaoView]!
    var shiYingLabels: [BodyLabel]!
    
    // MARK: - Input Rx
    let bag = DisposeBag()
    let guaXiangRelay = PublishRelay<LiuYaoGuaXiang>()
    
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
private extension ShiYingYaoView {
    func setup() {
        backgroundColor = nil
        
        setupYaoViews()
        setupShiYingLabels()
        constraints()
        
        styling()
    }
    
    func setupYaoViews() {
        yaoViews = (1...6).map { makeYaoView(at: $0) }.map {
            addSubview($0)
            return $0
        }
    }
    
    func makeYaoView(at position: Int) -> YaoView {
        let yaoView = YaoView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        yaoView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 56, height: 36))
        }
        
        guaXiangRelay.map { $0.yao(at: position) }
            .bind(to: yaoView.yaoRelay)
            .disposed(by: bag)
        
        return yaoView
    }
}

// MARK: - Shi Ying labels
private extension ShiYingYaoView {
    func setupShiYingLabels() {
        shiYingLabels = (1...6).map { makeShiYingLabel(at: $0) }.map {
            addSubview($0)
            return $0
        }
    }
    
    func makeShiYingLabel(at position: Int) -> BodyLabel {
        let label = BodyLabel(frame: .zero)
        label.text = " "
        
        guaXiangRelay.map { ($0.originalGua.shi, $0.originalGua.ying) }
            .bind { shi, ying in
                if position == shi {
                    label.text = "世"
                } else if position == ying {
                    label.text = "應"
                } else {
                    label.text = " "
                }
            }.disposed(by: bag)
        
        return label
    }
    
    func constraints() {
        
        yaoViews.first!.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        shiYingLabels.last!.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        // Equal to eachother
        yaoViews.suffix(5).forEach { yaoView in
            yaoView.snp.makeConstraints({ make in
                make.height.equalTo(yaoViews.first!)
            })
        }
        
        shiYingLabels.suffix(5).forEach { shiYingLabel in
            shiYingLabel.snp.makeConstraints({ make in
                make.height.equalTo(shiYingLabels.first!)
            })
        }
        
        // Between same yao and shi ying
        zip(yaoViews, shiYingLabels).forEach { yaoView, shiYingLabel in
            shiYingLabel.snp.makeConstraints { make in
                make.bottom.equalTo(yaoView.snp.top)
            }
        }
        
        // In between different yao and shi ying
        zip(yaoViews.suffix(5), shiYingLabels.prefix(5)).forEach { upperYaoView, lowerShiYingLabel in
            lowerShiYingLabel.snp.makeConstraints({ make in
                make.top.equalTo(upperYaoView.snp.bottom).offset(16)
            })
        }
        
        // Center horizontally
        yaoViews.forEach { $0.snp.makeConstraints { $0.centerX.equalToSuperview() } }
        shiYingLabels.forEach { $0.snp.makeConstraints { $0.centerX.equalToSuperview() } }
        
        yaoViews.forEach {
            $0.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
        }
    }
    
    func styling() {
        shiYingLabels.forEach { label in
            label.font = .scaled(.body3Medium)
        }
    }
}
