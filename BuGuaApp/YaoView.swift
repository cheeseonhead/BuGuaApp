//
//  YaoView.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxCocoa
import RxSwift
import UIKit

class YaoView: UIView {

    // MARK: - Constants
    let preferredSize = CGSize(width: 48, height: 36)

    // MARK: - Public Rx
    let yaoRelay = PublishRelay<YaoType>()

    // MARK: - Private properties
    private var yaoLayer: CALayer!
    private var layerDelegate: YaoLayerDelegate!
    private let bag = DisposeBag()

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
    override func setNeedsDisplay() {
        super.setNeedsDisplay()

        yaoLayer?.setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        yaoLayer?.setNeedsDisplay()
    }
}

// MARK: - Setup
private extension YaoView {
    func setup() {
        backgroundColor = nil

        addYaoLayer()

        yaoRelay.bind { [unowned self] yaoType in
            self.layerDelegate.yaoType = yaoType
            self.setNeedsDisplay()
        }.disposed(by: bag)
    }

    func addYaoLayer() {
        yaoLayer = CALayer()
        yaoLayer.contentsScale  = UIScreen.main.scale
        yaoLayer.frame = bounds

        layerDelegate = YaoLayerDelegate()
        yaoLayer.delegate = layerDelegate

        self.layer.addSublayer(yaoLayer)
    }
}

private class YaoLayerDelegate: NSObject, CALayerDelegate {

    var yaoType: YaoType = .oldYang

    func draw(_ layer: CALayer, in ctx: CGContext) {

        guard let superlayer = layer.superlayer else { return }

        layer.frame = superlayer.bounds

        switch yaoType {
        case .youngYang: drawYoungYang(layer, in: ctx)
        case .youngYin: drawYoungYin(layer, in: ctx)
        case .oldYang: drawOldYang(layer, in: ctx)
        case .oldYin: drawOldYin(layer, in: ctx)
        }
    }

    // MARK: - Draw Young Yang
    private func drawYoungYang(_ layer: CALayer, in ctx: CGContext) {
        let strokeWidth: CGFloat = 8
        let frameToDrawIn = frame(in: layer.bounds, widthOverHeight: 0.7897838950157166).scaledAtCenter(scaleX: 0.3, scaleY: 0.3)

        ctx.beginPath()
        ctx.addLines(between: [frameToDrawIn.origin, frameToDrawIn.bottomRight])

        ctx.setStrokeColor(UIColor.spaceGrey.cgColor)
        ctx.setLineWidth(strokeWidth)
        ctx.setLineCap(.round)
        ctx.drawPath(using: .stroke)
    }

    // MARK: - Draw Young Yin
    private func drawYoungYin(_ layer: CALayer, in ctx: CGContext) {
        let strokeWidth: CGFloat = 8
        let spacing: CGFloat = 16.797642409801483
        let frameToDrawIn = frame(in: layer.bounds, widthOverHeight: 0.7897838950157166).scaledAtCenter(scaleX: 0.3, scaleY: 0.3)

        let leftFrame = frameToDrawIn.applying(.init(translationX: -spacing, y: 0))
        let rightFrame = frameToDrawIn.applying(.init(translationX: spacing, y: 0))

        ctx.beginPath()
        ctx.addLines(between: [leftFrame.origin, leftFrame.bottomRight])
        ctx.addLines(between: [rightFrame.origin, rightFrame.bottomRight])

        ctx.setStrokeColor(UIColor.spaceGrey.cgColor)
        ctx.setLineWidth(strokeWidth)
        ctx.setLineCap(.round)
        ctx.drawPath(using: .stroke)
    }

    // MARK: - Draw Old Yang

    private func drawOldYang(_ layer: CALayer, in ctx: CGContext) {
        let strokeWidth: CGFloat = 8
        let inset = strokeWidth / 2
        let frameToDrawIn = frame(in: layer.bounds, widthOverHeight: 0.974459707736969).insetBy(dx: inset, dy: inset)

        ctx.beginPath()
        ctx.addEllipse(in: frameToDrawIn)

        ctx.setStrokeColor(UIColor.spaceGrey.cgColor)
        ctx.setLineWidth(strokeWidth)
        ctx.setLineCap(.round)
        ctx.drawPath(using: .stroke)
    }

    // MARK: - Draw Old Yin

    private func drawOldYin(_ layer: CALayer, in ctx: CGContext) {
        let strokeWidth: CGFloat = 8
        let inset = strokeWidth / 2
        let frameToDrawIn = frame(in: layer.bounds.applying(.init(scaleX: 1, y: 0.9)), widthOverHeight: tan((80 / 180) * .pi / 2))

        ctx.beginPath()
        ctx.move(to: frameToDrawIn.origin + CGPoint(x: inset, y: inset))
        ctx.addLine(to: frameToDrawIn.bottomRight - CGPoint(x: inset, y: inset))
        ctx.move(to: frameToDrawIn.topRight + CGPoint(x: -inset, y: inset))
        ctx.addLine(to: frameToDrawIn.bottomLeft - CGPoint(x: -inset, y: inset))

        ctx.setStrokeColor(UIColor.spaceGrey.cgColor)
        ctx.setLineWidth(strokeWidth)
        ctx.setLineCap(.round)
        ctx.drawPath(using: .stroke)
    }

    // MARK: - Helper

    /// radian is the angle of the top and bottom V's.
    private func frame(in bounds: CGRect, widthOverHeight: CGFloat) -> CGRect {
        let newFrame: CGRect
        if bounds.height <= bounds.width {
            newFrame = CGRect(origin: .zero, size: CGSize(width: widthOverHeight * bounds.height, height: bounds.height))
        } else {
            newFrame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.width / widthOverHeight))
        }

        let translation = bounds.center - newFrame.center
        return newFrame.applying(.init(translationX: translation.x, y: translation.y))
    }
}
