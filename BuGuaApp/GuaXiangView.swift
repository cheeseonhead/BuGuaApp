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
        setupDiZhiLabels()
    }

    func createConstraints() {
        diZhiView.snp.makeConstraints { make in
            make.leading.equalTo(shiYingYaoView.snp.trailing).offset(16)
        }
        GuaXiangViewLayout.verticalAlignSixLabelView(diZhiView, shiYingYaoView: shiYingYaoView)
    }

    func bindings() {
        guaXiangRelay.bind(to: shiYingYaoView.guaXiangRelay)
            .disposed(by: bag)
        guaXiangRelay.map { $0.originalGua.yaoZhi.map { $0.character } }
            .bind(to: diZhiView.dataRelay)
            .disposed(by: bag)
    }
}

// MARK: - Shi Ying Yao View
private extension GuaXiangView {
    func setupShiYingYaoView() {
        shiYingYaoView = ShiYingYaoView(frame: .zero)
        
        addSubview(shiYingYaoView)
        
        shiYingYaoView.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-8)
        }
    }
}

// MARK: - DiZhi Labels
private extension GuaXiangView {
    func setupDiZhiLabels() {
        diZhiView = SixLabelView(frame: .zero)
        
        addSubview(diZhiView)
    }
}
