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

extension UIView {

    enum LayoutAnchor {
        case top, bottom, leading, trailing

        var keyPath: AnyKeyPath {
            switch self {
            case .top: return \topAnchor
            case .bottom: return \bottomAnchor
            case .leading: return \leadingAnchor
            case .trailing: return \trailingAnchor
            }
        }
    }

    @discardableResult
    func anchorHeight(to height: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }

    @discardableResult
    func anchorWidth(to width: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }

    @discardableResult
    func centerX(useSafeArea: Bool, offset: CGFloat = 0) -> Self {
        let superAnchor = useSafeArea ? superview!.safeAreaLayoutGuide.centerXAnchor : superview!.centerXAnchor
        centerXAnchor.constraint(equalTo: superAnchor, constant: offset).isActive = true

        return self
    }

    @discardableResult
    func centerY(useSafeArea: Bool, offset: CGFloat = 0) -> Self {
        let superAnchor = useSafeArea ? superview!.safeAreaLayoutGuide.centerYAnchor : superview!.centerYAnchor
        centerYAnchor.constraint(equalTo: superAnchor, constant: offset).isActive = true

        return self
    }

    @discardableResult
    func center(useSafeArea: Bool) -> Self {
        return centerX(useSafeArea: useSafeArea).centerY(useSafeArea: useSafeArea)
    }

    @discardableResult
    func anchorTop(useSafeArea: Bool, offset: CGFloat = 0) -> Self {
        let superAnchor = useSafeArea ? superview!.safeAreaLayoutGuide.topAnchor : superview!.topAnchor
        topAnchor.constraint(equalTo: superAnchor, constant: offset).isActive = true
        return self
    }

    @discardableResult
    func anchorBottom(useSafeArea: Bool, offset: CGFloat = 0) -> Self {
        let superAnchor = useSafeArea ? superview!.safeAreaLayoutGuide.bottomAnchor : superview!.bottomAnchor
        bottomAnchor.constraint(equalTo: superAnchor, constant: offset).isActive = true
        return self
    }

    @discardableResult
    func anchorLeading(useSafeArea: Bool, offset: CGFloat = 0) -> Self {
        let superAnchor = useSafeArea ? superview!.safeAreaLayoutGuide.leadingAnchor : superview!.leadingAnchor
        leadingAnchor.constraint(equalTo: superAnchor, constant: offset).isActive = true
        return self
    }

    @discardableResult
    func anchorTrailing(useSafeArea: Bool, offset: CGFloat = 0) -> Self {
        let superAnchor = useSafeArea ? superview!.safeAreaLayoutGuide.trailingAnchor : superview!.trailingAnchor
        trailingAnchor.constraint(equalTo: superAnchor, constant: offset).isActive = true
        return self
    }

    @discardableResult
    func anchorFillHeight(useSafeArea: Bool, inset: CGFloat = 0) -> Self {
        return anchorTop(useSafeArea: useSafeArea, offset: inset).anchorBottom(useSafeArea: useSafeArea, offset: -inset)
    }
}
