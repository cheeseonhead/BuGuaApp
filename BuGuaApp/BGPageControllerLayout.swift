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
    /// This is the bounds of the whole view owning the scroll view.
    let bounds: CGRect
    /// This is used for insetting the top and bottom of the pages. As well as deciding how much of the next page to
    /// "peek" out
    let inset: CGFloat
    /// The minimum amount of spacing between two pages
    let minimumPageSpacing: CGFloat
    /// The maximum of either dimension for a page. This prevents the page from growing too big on larger screens.
    let maxContentSize: CGSize
    /// This is the minimum page width when more than one page is going to fit on the screen. It is ignored when
    /// only one page can fit.
    let minimumMultipageWidth: CGFloat
    /// The total amount of pages there are, used for content view size calculation.
    let totalNumberOfPages: Int

    init(bounds: CGRect, inset: CGFloat, minimumPageSpacing: CGFloat, maxContentSize: CGSize, minimumMultipageWidth: CGFloat, totalNumberOfPages: Int) {
        self.bounds = bounds
        self.inset = inset
        self.minimumPageSpacing = minimumPageSpacing
        self.maxContentSize = maxContentSize
        self.minimumMultipageWidth = minimumMultipageWidth
        self.totalNumberOfPages = totalNumberOfPages
    }

    private(set) lazy var pageFrames: [CGRect] = {
        var currentLeft = actualInterPageSpacing / 2
        let top = inset

        var frames = [CGRect]()
        for _ in 1 ... totalNumberOfPages {
            let frame = CGRect(origin: CGPoint(x: currentLeft, y: top), size: fittingPageSize)
            frames.append(frame)
            currentLeft += fittingPageSize.width + actualInterPageSpacing
        }

        return frames
    }()

    private(set) lazy var scrollViewFrame: CGRect = {
        let viewsWidth = fittingPageSize.width * CGFloat(numberOfPagesAtOnce)
        let totalSpacingWidth = actualInterPageSpacing * CGFloat(numberOfPagesAtOnce)
        let finalWidth = viewsWidth + totalSpacingWidth

        let finalHeight = scrollViewHeight

        let finalBounds = CGRect(x: 0, y: 0, width: finalWidth, height: finalHeight)

        return finalBounds.centeredAt(bounds.center)
    }()

    private(set) lazy var scrollViewContentSize: CGSize = {
        let finalHeight = scrollViewHeight
        let totalPagesWidth = fittingPageSize.width * CGFloat(totalNumberOfPages)
        let totalSpacingWidth = actualInterPageSpacing * CGFloat(totalNumberOfPages)
        let finalWidth = totalPagesWidth + totalSpacingWidth

        return CGSize(width: finalWidth, height: finalHeight)
    }()

    /// The actual spacing that gets calculated after page size has been determined. Might be larger than minimumPageSpacing
    /// because peeking the right value is more important.
    private(set) lazy var actualInterPageSpacing: CGFloat = {
        let totalWidth = bounds.width
        let horizontalOccupiedByPages = inset * 2 + fittingPageSize.width * CGFloat(numberOfPagesAtOnce)
        let numberOfSpaces = numberOfPagesAtOnce + 1

        let blankLength = totalWidth - horizontalOccupiedByPages

        return blankLength / CGFloat(numberOfSpaces)
    }()

    private(set) lazy var scrollViewHeight: CGFloat = {
        inset * 2 + fittingPageSize.height
    }()

    /// The actual size the embedded view controllers will have, derived from the maximum possible one and the given
    /// preferred maximum.
    private(set) lazy var fittingPageSize: CGSize = {
        let maxPossibleWidth = pageWidth(numberOfPages: numberOfPagesAtOnce)

        let fittingWidth = min(maxPossibleWidth, maxContentSize.width)

        let maxPossibleHeight = bounds.height - inset * 2

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

    /// The widest a page can be given the minimum spacing and current bounds.
    func pageWidth(numberOfPages number: Int) -> CGFloat {
        let totalWidth = bounds.size.width
        let totalSpacings = 2 * inset + CGFloat(number + 1) * minimumPageSpacing

        let totalAvailableWidth = totalWidth - totalSpacings
        let widthPerContent = totalAvailableWidth / CGFloat(number)

        return widthPerContent
    }
}

infix operator =>
private func => <T, U>(_ input: T, closure: (T) -> U) -> U {
    return closure(input)
}
