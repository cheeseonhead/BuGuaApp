//
//  UIView+Layout.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-29.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

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
