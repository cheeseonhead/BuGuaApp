//
//  YaoView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

class YaoView: UIView {

    // MARK: - Constants
    let preferredSize = CGSize(width: 48, height: 16)

    // MARK: - Private properties
    private let oldYinLayerDelegate = OldYinLayerDelegate()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setPaths()
    }
}

// MARK: - Setup
private extension YaoView {
    func setup() {
        backgroundColor = nil
        clipsToBounds = false

        addOldYinLayer()
    }

    func addOldYinLayer() {
        let yaoLayer = CALayer()
        yaoLayer.contentsScale  = UIScreen.main.scale
        yaoLayer.delegate = oldYinLayerDelegate
        yaoLayer.frame = bounds
        yaoLayer.setNeedsDisplay()
        self.layer.addSublayer(yaoLayer)
    }

    func setPaths() {

    }
}

private class OldYinLayerDelegate: NSObject, CALayerDelegate {
    func draw(_ layer: CALayer, in ctx: CGContext) {
        print("Draw called")

        let strokeWidth: CGFloat = 8
        let inset = strokeWidth / 2
        let frameToDrawIn = frame(in: layer.bounds, radian: (80 / 180) * .pi)

        ctx.move(to: frameToDrawIn.origin + CGPoint(x: inset, y: inset))
        ctx.addLine(to: frameToDrawIn.bottomRight - CGPoint(x: inset, y: inset))
        ctx.move(to: frameToDrawIn.topRight + CGPoint(x: -inset, y: inset))
        ctx.addLine(to: frameToDrawIn.bottomLeft - CGPoint(x: -inset, y: inset))

        ctx.setStrokeColor(UIColor.spaceGrey.cgColor)
        ctx.setLineWidth(strokeWidth)
        ctx.setLineCap(.round)
        ctx.drawPath(using: .stroke)
    }

    /// radian is the angle of the top and bottom V's.
    private func frame(in bounds: CGRect, radian: CGFloat) -> CGRect {
        let widthOverHeight = tan(radian / 2)

        let size: CGSize
        if bounds.height <= bounds.width {
            size = CGSize(width: widthOverHeight * bounds.height, height: bounds.height)
        } else {
            size = CGSize(width: bounds.width, height: bounds.width / widthOverHeight)
        }

        let translation = bounds.center - size.center
        return CGRect(origin: translation, size: size)
    }
}
