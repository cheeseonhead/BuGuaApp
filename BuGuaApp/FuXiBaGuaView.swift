//
//  FuXiBaGuaView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import RxSwift
import RxCocoa
import UIKit

@IBDesignable
class FuXiBaGuaView: UIView, NibLoadable {

    // MARK: - Views
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var topCenter: UIView!
    @IBOutlet weak var middleCenter: UIView!
    @IBOutlet weak var bottomCenter: UIView!
    lazy var centerViews: [UIView] = [bottomCenter, middleCenter, topCenter]

    // MARK: - Public Properties
    let baGuaRelay = BehaviorRelay(value: FuXiBaGua.qian)

    // MARK: - Private Properties
    let disposeBag = DisposeBag()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
}

// MARK: - Setup
private extension FuXiBaGuaView {

    func setup() {
        loadNib()
        setProperties()
        setBindings()
    }

    func setProperties() {
        semanticContentAttribute = .forceLeftToRight
        backgroundColor = nil
    }

    func setBindings() {
        baGuaRelay.bind(onNext: { [unowned self] in self.renderViews(baGua: $0) })
        .disposed(by: disposeBag)
    }
}

// MARK: - Rendering
private extension FuXiBaGuaView {
    func renderViews(baGua: FuXiBaGua) {

        zip(centerViews, [FuXiBaGua.Position.bottom, .middle, .top])
            .forEach { centerView, position in
                let liangYi = baGua.yao(at: position)

                switch liangYi {
                case .yang: centerView.backgroundColor = .black
                case .yin: centerView.backgroundColor = nil
                }
            }
    }
}
