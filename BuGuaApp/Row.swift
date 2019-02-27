//
//  Row.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2019-02-26.
//  Copyright © 2019 Jeffrey Wu. All rights reserved.
//

import UIKit

struct Row {
    enum Element {
        case view(UIView, Dimension)
        case space(Length)

        case stack(Stack)
    }

    var elements: [Element]

    init(elements: [Element]) {
        self.elements = elements
    }

    var minHeight: CGFloat {
        return elements.reduce(0) { max($0, $1.minHeight) }
    }

    var minWidth: CGFloat {
        return elements.reduce(0) { $0 + $1.minWidth }
    }

    var numOfWidthFlexibleElements: Int {
        return elements.count { $0.isWidthFlexible }
    }

    var isWidthFlexible: Bool {
        return elements.contains { $0.isWidthFlexible }
    }

    var isHeightFlexible: Bool {
        return elements.contains { $0.isHeightFlexible }
    }

    var dimension: Dimension {
        return Dimension(CGSize(width: minWidth, height: minHeight),
                         SizeFlexibility(width: .flexible, height: .init(isFlexible: isHeightFlexible))
        )
    }

    mutating func appendElement(_ element: Element) {
        elements.append(element)
    }

    func apply(_ adjustment: Dimension.Adjustment, topLeft: CGPoint) -> (views: [UIView], newY: CGFloat) {
        let rowSize = dimension.renderValue(adjustment)

        let totalExtraWidth = rowSize.width - minWidth
        let extraSpaceEachFlexible = totalExtraWidth / CGFloat(numOfWidthFlexibleElements)

        var views: [UIView] = []
        var x: CGFloat = topLeft.x
        for e in elements {
            switch e {
            case let .view(v, dim):
                let size = dim.renderValue(.init(width: .extra(extraSpaceEachFlexible), height: .available(rowSize.height)))
                let origin = CGPoint(x: x, y: topLeft.y)
                v.frame = CGRect(origin: origin, size: size)
                views.append(v)

                x += size.width
            case let .stack(stack):
                let size = stack.dimension.renderValue(.init(width: .extra(extraSpaceEachFlexible), height: .available(rowSize.height)))
                let origin = CGPoint(x: x, y: topLeft.y)
                let subviews = stack.apply(.init(available: size), topLeft: origin)
                views.append(contentsOf: subviews)

                x += size.width
            case let .space(length):
                x += length.renderValue(.extra(extraSpaceEachFlexible))
            }
        }

        return (views, topLeft.y + rowSize.height)
    }

    static func + (lhs: Row, rhs: Row) -> Row {
        return Row(elements: lhs.elements + rhs.elements)
    }
}

extension Row.Element {
    var minHeight: CGFloat {
        switch self {
        case let .view(_, dim):
            return dim.height.min
        case let .stack(stack):
            return stack.minHeight
        case .space:
            return 0
        }
    }

    var minWidth: CGFloat {
        switch self {
        case let .view(_, dim):
            return dim.width.min
        case let .stack(stack):
            return stack.minWidth
        case let .space(l):
            return l.min
        }
    }

    var isWidthFlexible: Bool {
        switch self {
        case let .view(_, dim):
            return dim.isWidthFlexible
        case let .stack(stack):
            return stack.isWidthFlexible
        case let .space(l):
            return l.isFlexible
        }
    }

    var isHeightFlexible: Bool {
        switch self {
        case let .view(_, dim):
            return dim.isHeightFlexible
        case let .stack(stack):
            return stack.isHeightFlexible
        case .space:
            return false
        }
    }
}
