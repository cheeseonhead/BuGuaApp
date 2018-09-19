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
    var changedGanZhiView: SixLabelView!
    var changedLiuQinView: SixLabelView!
    
    // MARK: - Properties
    let guaXiangRelay = PublishRelay<LiuYaoGuaXiang>()

    // MARK: - Private Constants
    private let columnSpacing = 16
    
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
        setupChangedGanZhiView()
        setupChangedLiuQinView()
    }

    func createConstraints() {
        shiYingYaoView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(safeAreaLayoutGuide)
//            make.bottom.equalTo(safeAreaLayoutGuide).offset(-8)
        }
        
        liuQinView.snp.makeConstraints { $0.trailing.equalTo(shiYingYaoView.snp.leading).offset(-columnSpacing) }
        changedLiuQinView.snp.makeConstraints { $0.trailing.equalTo(liuQinView.snp.leading).offset(-columnSpacing) }
        fuShenView.snp.makeConstraints { $0.trailing.equalTo(changedLiuQinView.snp.leading).offset(-columnSpacing) }
        
        diZhiView.snp.makeConstraints { $0.leading.equalTo(shiYingYaoView.snp.trailing).offset(columnSpacing) }
        changedGanZhiView.snp.makeConstraints { $0.leading.equalTo(diZhiView.snp.trailing).offset(columnSpacing) }
        hiddenGanZhiView.snp.makeConstraints { $0.leading.equalTo(changedGanZhiView.snp.trailing).offset(columnSpacing) }

        let columnViews: [UIView] = [fuShenView, changedLiuQinView, liuQinView, shiYingYaoView, diZhiView, changedGanZhiView, hiddenGanZhiView]
        columnViews.first!.snp.makeConstraints { $0.leading.equalToSuperview().offset(columnSpacing) }
        columnViews.last!.snp.makeConstraints { $0.trailing.equalToSuperview().offset(-columnSpacing) }

        GuaXiangViewLayout.verticalAlignSixLabelView(diZhiView, shiYingYaoView: shiYingYaoView)
        GuaXiangViewLayout.verticalAlignSixLabelView(liuQinView, shiYingYaoView: shiYingYaoView)
        GuaXiangViewLayout.verticalAlignSixLabelView(hiddenGanZhiView, shiYingYaoView: shiYingYaoView)
        GuaXiangViewLayout.verticalAlignSixLabelView(fuShenView, shiYingYaoView: shiYingYaoView)
        GuaXiangViewLayout.verticalAlignSixLabelView(changedGanZhiView, shiYingYaoView: shiYingYaoView)
        GuaXiangViewLayout.verticalAlignSixLabelView(changedLiuQinView, shiYingYaoView: shiYingYaoView)
        
        headerView.snp.makeConstraints { $0.bottom.equalTo(shiYingYaoView.snp.top).offset(-8) }
        GuaXiangViewLayout.alignHeader(headerView, columns: columnViews)

        horizontalDividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
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
            return zip(liuShiSiGua.tianGan, liuShiSiGua.diZhi).lazy
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
        
        guaXiangRelay.map(GuaXiangView.hiddenGanZhi)
            .bind(to: hiddenGanZhiView.dataRelay)
            .disposed(by: bag)
        
        addSubview(hiddenGanZhiView)
    }
    
    func setupFuShenView() {
        fuShenView = SixLabelView(frame: .zero)
        
        guaXiangRelay.map(GuaXiangView.fuShen)
            .bind(to: fuShenView.dataRelay)
            .disposed(by: bag)
        
        addSubview(fuShenView)
    }
    
    func setupChangedGanZhiView() {
        changedGanZhiView = SixLabelView(frame: .zero)
        
        guaXiangRelay.map(GuaXiangView.changeGanZhi)
            .bind(to: changedGanZhiView.dataRelay)
            .disposed(by: bag)
        
        addSubview(changedGanZhiView)
    }
    
    func setupChangedLiuQinView() {
        changedLiuQinView = SixLabelView(frame: .zero)
        
        guaXiangRelay.map(GuaXiangView.changeLiuQin)
            .bind(to: changedLiuQinView.dataRelay)
            .disposed(by: bag)
        
        addSubview(changedLiuQinView)
    }
}

// MARK: - Presentation Helpers
private extension GuaXiangView {
    static func hiddenGanZhi(from guaXiang: LiuYaoGuaXiang) -> [String] {
        let controller = FuShenController(guaXiang: guaXiang)
        
        let tianGan = controller.hiddenTianGan().map { $0?.character ?? "" }
        let diZhi = controller.hiddenDiZhi().map { $0?.character ?? "" }
        
        return zip(tianGan, diZhi).map {
            return ($0 + $1).vertical
        }
    }
    
    static func fuShen(from guaXiang: LiuYaoGuaXiang) -> [String] {
        let controller = FuShenController(guaXiang: guaXiang)
        
        return controller.fuShen().map { $0?.character.vertical ?? "" }
    }
    
    static func changeGanZhi(from guaXiang: LiuYaoGuaXiang) -> [String] {
        let tianGan = guaXiang.changedTianGan.lazy.map { $0?.character ?? "" }
        let diZhi = guaXiang.changedDiZhi.lazy.map { $0?.character ?? "" }
        
        return zip(tianGan, diZhi).map {
            return ($0 + $1).vertical
        }
    }
    
    static func changeLiuQin(from guaXiang: LiuYaoGuaXiang) -> [String] {
        return guaXiang.changedLiuQin.map {
            $0?.character.vertical ?? ""
        }
    }
}
