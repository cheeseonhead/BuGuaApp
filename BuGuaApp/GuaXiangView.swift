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
    var headerView: HeaderLabelView!
    var shiYingYaoView: ShiYingYaoView!
    var diZhiView: SixLabelView!
    var liuQinView: SixLabelView!
    var horizontalDividerView: HorizontalDividersView!
    var hiddenGanZhiView: SixLabelView!
    var fuShenView: SixLabelView!

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
        setupHeaderView()
        setupHorizontalDivders()
        setupHiddenGanZhiView()
        setupFuShenView()
    }

    func createConstraints() {
        shiYingYaoView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(safeAreaLayoutGuide)
//            make.bottom.equalTo(safeAreaLayoutGuide).offset(-8)
        }
        
        liuQinView.snp.makeConstraints { $0.trailing.equalTo(shiYingYaoView.snp.leading).offset(-16) }
        diZhiView.snp.makeConstraints { $0.leading.equalTo(shiYingYaoView.snp.trailing).offset(16) }
        hiddenGanZhiView.snp.makeConstraints { $0.leading.equalTo(diZhiView.snp.trailing).offset(16) }
        fuShenView.snp.makeConstraints { $0.trailing.equalTo(liuQinView.snp.leading).offset(-16) }
        
        GuaXiangViewLayout.verticalAlignSixLabelView(diZhiView, shiYingYaoView: shiYingYaoView)
        GuaXiangViewLayout.verticalAlignSixLabelView(liuQinView, shiYingYaoView: shiYingYaoView)
        GuaXiangViewLayout.verticalAlignSixLabelView(hiddenGanZhiView, shiYingYaoView: shiYingYaoView)
        GuaXiangViewLayout.verticalAlignSixLabelView(fuShenView, shiYingYaoView: shiYingYaoView)
        
        headerView.snp.makeConstraints { $0.bottom.equalTo(shiYingYaoView.snp.top).offset(-8) }
        GuaXiangViewLayout.alignHeader(headerView, columns: [fuShenView, liuQinView, shiYingYaoView, diZhiView, hiddenGanZhiView])
        
        horizontalDividerView.snp.makeConstraints { $0.leading.trailing.equalToSuperview() }
        GuaXiangViewLayout.alignHorizontalDividers(horizontalDividerView, shiYingYaoView: shiYingYaoView, headerView: headerView)
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
        
        func ganZhi(_ liuShiSiGua: LiuShiSiGua) -> [String] {
            return zip(liuShiSiGua.tianGan, liuShiSiGua.yaoZhi).lazy
                .map { ($0.0.character + $0.1.character).vertical }
        }
        
        guaXiangRelay.map { ganZhi($0.originalGua) }
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
    
    func setupHeaderView() {
        headerView = HeaderLabelView(frame: .zero)
        
        addSubview(headerView)
    }
    
    func setupHorizontalDivders() {
        horizontalDividerView = HorizontalDividersView(frame: .zero)
        
        addSubview(horizontalDividerView)
    }
    
    func setupHiddenGanZhiView() {
        hiddenGanZhiView = SixLabelView(frame: .zero)
        
        guaXiangRelay.map(hiddenGanZhi)
            .bind(to: hiddenGanZhiView.dataRelay)
            .disposed(by: bag)
        
        addSubview(hiddenGanZhiView)
    }
    
    func setupFuShenView() {
        fuShenView = SixLabelView(frame: .zero)
        
        guaXiangRelay.map(fuShen)
            .bind(to: fuShenView.dataRelay)
            .disposed(by: bag)
        
        addSubview(fuShenView)
    }
}

// MARK: - Presentation Helpers
private extension GuaXiangView {
    func hiddenGanZhi(from guaXiang: LiuYaoGuaXiang) -> [String] {
        let controller = FuShenController(guaXiang: guaXiang)
        
        let tianGan = controller.hiddenTianGan().map { $0?.character ?? "" }
        let diZhi = controller.hiddenDiZhi().map { $0?.character ?? "" }
        
        return zip(tianGan, diZhi).map {
            return ($0 + $1).vertical
        }
    }
    
    func fuShen(from guaXiang: LiuYaoGuaXiang) -> [String] {
        let controller = FuShenController(guaXiang: guaXiang)
        
        return controller.fuShen().map { $0?.character.vertical ?? "" }
    }
}
