//
//  Stack.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2019-02-26.
//  Copyright © 2019 Jeffrey Wu. All rights reserved.
//

import UIKit

struct Stack {
    enum Layer {
        case row(Row)
        case space(Length)
    }

    var layers: [Layer]
    var numOfHeightFlexibleElements: Int {
        return layers.reduce(0) { $1.isHeightFlexible ? $0 + 1 : $0 }
    }

    var minWidth: CGFloat {
        return layers.reduce(0) { max($0, $1.minWidth) }
    }

    var minHeight: CGFloat {
        return layers.reduce(0) { $0 + $1.minHeight }
    }

    var minSize: CGSize {
        return CGSize(width: minWidth, height: minHeight)
    }

    var dimension: Dimension {
        return Dimension(minSize, .flexible)
    }

    var isWidthFlexible: Bool {
        return layers.contains { $0.isWidthFlexible }
    }

    var isHeightFlexible: Bool {
        return layers.contains { $0.isHeightFlexible }
    }

    mutating func appendLayer(_ layer: Layer) {
        layers.append(layer)
    }

    func appendingLayer(_ layer: Layer) -> Stack {
        return Stack(layers: layers + [layer])
    }

    func apply(_ adjustment: Dimension.Adjustment, topLeft: CGPoint) -> [UIView] {
        let stackSize = dimension.renderValue(adjustment)

        let totalExtraVerticalSpace = stackSize.height - minHeight
        let extraHeightForEach = totalExtraVerticalSpace / CGFloat(numOfHeightFlexibleElements)

        var views: [UIView] = []
        var yPos: CGFloat = topLeft.y
        for e in layers {
            switch e {
            case let .row(r):
                let adj = Dimension.Adjustment(width: .available(stackSize.width), height: .extra(extraHeightForEach))
                let resp = r.apply(adj, topLeft: CGPoint(x: topLeft.x, y: yPos))
                views.append(contentsOf: resp.views)

                yPos = resp.newY
            case let .space(l):
                yPos += l.renderValue(.extra(extraHeightForEach))
            }
        }

        return views
    }

    static func + (lhs: Stack, rhs: Stack) -> Stack {
        guard let leftLast = lhs.layers.last else { return rhs }
        guard let rightFirst = rhs.layers.first else { return lhs }

        switch (leftLast, rightFirst) {
        case (.space, _): fallthrough
        case (_, .space): return Stack(layers: lhs.layers + rhs.layers)
        case let (.row(lr), .row(rr)):
            let elements = lhs.layers.dropLast() + [Layer.row(lr + rr)] + rhs.layers.dropFirst()
            return Stack(layers: Array(elements))
        }
    }
}

extension Stack.Layer {
    var minWidth: CGFloat {
        switch self {
        case let .row(r):
            return r.minWidth
        case .space:
            return 0
        }
    }

    var minHeight: CGFloat {
        switch self {
        case let .row(r):
            return r.minHeight
        case let .space(l):
            return l.min
        }
    }

    var isHeightFlexible: Bool {
        switch self {
        case let .row(r):
            return r.isHeightFlexible
        case let .space(l):
            return l.isFlexible
        }
    }

    var isWidthFlexible: Bool {
        switch self {
        case let .row(r):
            return r.isWidthFlexible
        case .space:
            return false
        }
    }
}
