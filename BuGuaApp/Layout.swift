//
//  Layout.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2019-02-26.
//  Copyright © 2019 Jeffrey Wu. All rights reserved.
//

import UIKit

indirect enum Layout {
    case view(UIView, Dimension, Layout)
    case contentView(UIView, SizeFlexibility, Layout)
    case space(Length, Layout)
    case newline(Length, Layout)

    case box(Layout, Layout)
    case choice(Layout, Layout)
    case empty

    func computeStack(_ containerSize: CGSize, curOrigin: CGPoint) -> Stack {
        var origin = curOrigin
        var stack = Stack(layers: [])
        var row = Row(elements: [])
        var current = self

        while true {
            switch current {
            case let .view(v, dim, tail):
                row.appendElement(.view(v, dim))

                origin.x += dim.width.min
                current = tail
            case let .contentView(v, flexibility, tail):
                let availableSize = containerSize - CGSize(origin)
                let sizeThatFits = v.sizeThatFits(availableSize)
                row.appendElement(.view(v, Dimension(sizeThatFits, flexibility)))

                origin.x += sizeThatFits.width
                current = tail
            case let .space(length, tail):
                row.appendElement(.space(length))

                origin.x += length.min
                current = tail
            case let .newline(length, tail):
                stack.appendLayer(.row(row))
                stack.appendLayer(.space(length))
                row = Row(elements: [])

                origin.x = 0
                origin.y += row.minHeight
                current = tail
            case let .box(box, tail):
                let boxStack = box.computeStack(containerSize - CGSize(origin), curOrigin: .zero)
                row.appendElement(.stack(boxStack))

                origin.x += boxStack.minWidth
                origin.y += boxStack.minHeight
                current = tail
            case let .choice(left, right):
                var newStack = stack.appendingLayer(.row(row))
                let leftStack = left.computeStack(containerSize, curOrigin: origin)
                newStack = newStack + leftStack

                if containerSize.fits(newStack.minSize) {
                    return newStack
                } else {
                    current = right
                }
            case .empty:
                stack.appendLayer(.row(row))
                return stack
            }
        }
    }

    static func + (lhs: Layout, rhs: Layout) -> Layout {
        switch lhs {
        case let .contentView(v, flex, remainder):
            return .contentView(v, flex, remainder + rhs)
        case let .view(v, dim, tail):
            return .view(v, dim, tail + rhs)
        case let .space(l, r):
            return .space(l, r + rhs)
        case let .newline(l, r):
            return .newline(l, r + rhs)
        case let .box(b, r):
            return .box(b, r + rhs)
        case let .choice(l, r):
            return .choice(l + rhs, r + rhs)
        case .empty:
            return rhs
        }
    }
}

extension Layout {
    static func row(_ layouts: Layout...) -> Layout {
        return layouts.reversed().reduce(.empty) {
            $1 + $0
        }
    }

    static func stack(_ layouts: Layout..., spacing: Length) -> Layout {
        return layouts.reversed().reduce(.empty) {
            if case .empty = $0 {
                return $1 + $0
            } else {
                return $1 + (.newline(min: spacing.min, spacing.flexibility) + $0)
            }
        }
    }

    static func box(_ layout: Layout) -> Layout {
        return .box(layout, .empty)
    }

    static func contentView(_ view: UIView, _ flex: SizeFlexibility) -> Layout {
        return .contentView(view, flex, .empty)
    }

    static func boxView(_ view: UIView, _ flex: SizeFlexibility, _ minSize: CGSize) -> Layout {
        return .view(view, Dimension(minSize, flex), .empty)
    }

    static func space(min: CGFloat, _ flexibility: Flexibility) -> Layout {
        return .space(Length(flexibility, min), .empty)
    }

    static func newline(min: CGFloat, _ flexibility: Flexibility) -> Layout {
        return .newline(Length(flexibility, min), .empty)
    }

    static func or(_ layouts: Layout...) -> Layout {
        return layouts.reversed().reduce(.empty) {
            .choice($1, $0)
        }
    }
}
