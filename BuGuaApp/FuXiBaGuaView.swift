//
//  FuXiBaGuaView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit

@IBDesignable
class FuXiBaGuaView: UIView, NibLoadable {

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
    }
}
