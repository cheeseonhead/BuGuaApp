//
//  FuXiBaGuaView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import UIKit

@IBDesignable
class FuXiBaGuaView: UIView, NibLoadable {

    // MARK: - Views
    @IBOutlet weak var topCenter: UIView!
    @IBOutlet weak var middleCenter: UIView!
    @IBOutlet weak var bottomCenter: UIView!
    lazy var centerViews: [UIView] = [bottomCenter, middleCenter, topCenter]

    // MARK: - Properties
    var baGua: FuXiBaGua = .qian {
        didSet {
            render()
        }
    }

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
    }

    func setProperties() {
        semanticContentAttribute = .forceLeftToRight
        backgroundColor = nil
    }
}

// MARK: - Rendering
private extension FuXiBaGuaView {
    func render() {
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
