//
//  BGPageLayout.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

class BGPageControllerLayout {
    let bounds: CGRect
    let horizontalInset: CGFloat
    let contentSpacing: CGFloat
    let maxContentSize: CGSize
    let minimumMultipageWidth: CGFloat
    let totalNumberOfPages: Int

    init(bounds: CGRect, horizontalInset: CGFloat, contentSpacing: CGFloat, maxContentSize: CGSize, minimumMultipageWidth: CGFloat, totalNumberOfPages: Int) {
        self.bounds = bounds
        self.horizontalInset = horizontalInset
        self.contentSpacing = contentSpacing
        self.maxContentSize = maxContentSize
        self.minimumMultipageWidth = minimumMultipageWidth
        self.totalNumberOfPages = totalNumberOfPages
    }

    private(set) lazy var pageFrames: [CGRect] = {
        var currentLeft = contentSpacing / 2
        let top = contentSpacing

        var frames = [CGRect]()
        for _ in 1 ... totalNumberOfPages {
            let frame = CGRect(origin: CGPoint(x: currentLeft, y: top), size: fittingPageSize)
            frames.append(frame)
            currentLeft += fittingPageSize.width + contentSpacing
        }

        return frames
    }()

    private(set) lazy var scrollViewFrame: CGRect = {
        let viewsWidth = fittingPageSize.width * CGFloat(numberOfPagesAtOnce)
        let totalSpacingWidth = contentSpacing + actualInterPageSpacing * CGFloat(numberOfPagesAtOnce - 1)
        let finalWidth = viewsWidth + totalSpacingWidth

        let finalHeight = scrollViewHeight

        let finalBounds = CGRect(x: 0, y: 0, width: finalWidth, height: finalHeight)

        return finalBounds.centeredAt(bounds.center)
    }()

    private(set) lazy var scrollViewContentSize: CGSize = {
        let finalHeight = scrollViewHeight
        let finalWidth = fittingPageSize.width * CGFloat(totalNumberOfPages) + contentSpacing * CGFloat(totalNumberOfPages)

        return CGSize(width: finalWidth, height: finalHeight)
    }()

    private(set) lazy var actualInterPageSpacing: CGFloat = {
        let totalWidth = bounds.width
        let horizontalOccupiedByPages = horizontalInset * 2 + fittingPageSize.width * CGFloat(numberOfPagesAtOnce)
        let numberOfSpaces = numberOfPagesAtOnce + 1

        let blankLength = totalWidth - horizontalOccupiedByPages

        return blankLength / CGFloat(numberOfPagesAtOnce)
    }()

    private(set) lazy var scrollViewHeight: CGFloat = {
        contentSpacing * 2 + fittingPageSize.height
    }()

    /// The actual size the embedded view controllers will have, derived from the maximum possible one and the given
    /// preferred maximum.
    private(set) lazy var fittingPageSize: CGSize = {
        let maxPossibleWidth = pageWidth(numberOfPages: numberOfPagesAtOnce)

        let fittingWidth = min(maxPossibleWidth, maxContentSize.width)

        let maxPossibleHeight = bounds.height - contentSpacing * 2

        let fittingHeight = min(maxPossibleHeight, maxContentSize.height)

        return CGSize(width: fittingWidth, height: fittingHeight)
    }()

    /// The number of pages the controller will display at once
    private(set) lazy var numberOfPagesAtOnce: Int = {
        var numberOfPages = 1

        for n in 2 ... 10000 {
            if pageWidth(numberOfPages: n) < minimumMultipageWidth {
                break
            }
            numberOfPages = n
        }

        return numberOfPages
    }()

    func pageWidth(numberOfPages number: Int) -> CGFloat {
        let totalWidth = bounds.size.width
        let totalSpacings = 2 * horizontalInset + CGFloat(number + 1) * contentSpacing

        let totalAvailableWidth = totalWidth - totalSpacings
        let widthPerContent = totalAvailableWidth / CGFloat(number)

        return widthPerContent
    }
}

infix operator =>
private func => <T, U>(_ input: T, closure: (T) -> U) -> U {
    return closure(input)
}
