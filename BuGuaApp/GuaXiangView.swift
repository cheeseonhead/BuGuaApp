//
//  GuaXiangView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-28.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import RxSwift
import RxCocoa
import SnapKit
import UIKit

class GuaXiangView: UIView {

    // MARK: - Views
    var shiYingYaoView: ShiYingYaoView!
    var diZhiView: SixLabelView!
    var liuQinView: SixLabelView!

    // MARK: - Properties
    let guaXiangRelay = PublishRelay<LiuYaoGuaXiang>()

    // MARK: - Private
    let bag = DisposeBag()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }
}

// MARK: - Setup
private extension GuaXiangView {

    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = nil

        addViews()
        createConstraints()

        bindings()
    }

    func addViews() {
        setupShiYingYaoView()
        setupDiZhiView()
        setupLiuQinView()
    }

    func createConstraints() {
        shiYingYaoView.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-8)
        }
        
        diZhiView.snp.makeConstraints { make in
            make.leading.equalTo(shiYingYaoView.snp.trailing).offset(16)
        }
        GuaXiangViewLayout.verticalAlignSixLabelView(diZhiView, shiYingYaoView: shiYingYaoView)
        
        liuQinView.snp.makeConstraints { $0.trailing.equalTo(shiYingYaoView.snp.leading).offset(-16) }
        GuaXiangViewLayout.verticalAlignSixLabelView(liuQinView, shiYingYaoView: shiYingYaoView)
    }

    func bindings() {
    }
}

// MARK: - Setup Views
private extension GuaXiangView {
    func setupShiYingYaoView() {
        shiYingYaoView = ShiYingYaoView(frame: .zero)
        
        guaXiangRelay.bind(to: shiYingYaoView.guaXiangRelay)
            .disposed(by: bag)
        
        addSubview(shiYingYaoView)
    }
    
    func setupDiZhiView() {
        diZhiView = SixLabelView(frame: .zero)
        
        guaXiangRelay.map { $0.originalGua.yaoZhi.map { $0.character } }
            .bind(to: diZhiView.dataRelay)
            .disposed(by: bag)
        
        addSubview(diZhiView)
    }
    
    func setupLiuQinView() {
        liuQinView = SixLabelView(frame: .zero)

        guaXiangRelay.map { $0.originalGua.liuQin.map { $0.character.vertical } }
            .bind(to: liuQinView.dataRelay)
            .disposed(by: bag)
        
        addSubview(liuQinView)
    }
}
