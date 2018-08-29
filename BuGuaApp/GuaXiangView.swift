//
//  GuaXiangView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-28.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import UIKit

@IBDesignable
class GuaXiangView: UIView {

    // MARK: - Views
    var innerGuaView: FuXiBaGuaView!
    var outerGuaView: FuXiBaGuaView!

    // MARK: - Properties
    var guaXiang: LiuYaoGuaXiang?

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
        setupBaGuaViews()
    }

    func setupBaGuaViews() {

        innerGuaView = makeBaGuaView()
        outerGuaView = makeBaGuaView()
        outerGuaView.baGuaRelay.accept(.kun)

        let centerStackView = UIStackView(arrangedSubviews: [innerGuaView, outerGuaView])
        centerStackView.translatesAutoresizingMaskIntoConstraints = false

        centerStackView.axis = .vertical
        centerStackView.spacing = 48


        addSubview(centerStackView)
        centerStackView.center(useSafeArea: true)
        centerStackView.anchorFillHeight(useSafeArea: true)
    }

    func makeBaGuaView() -> FuXiBaGuaView {
        let baGuaView = FuXiBaGuaView(frame: CGRect.zero)

//        baGuaView.anchorHeight(to: ).anchorWidth(to: 500)
        baGuaView.heightAnchor.constraint(equalTo: baGuaView.widthAnchor).isActive = true

        return baGuaView
    }
}
