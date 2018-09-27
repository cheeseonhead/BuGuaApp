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
    let horizontalInset: CGFloat
    let contentSpacing: CGFloat
    let maxContentSize: CGSize
    let minimumMultipageWidth: CGFloat

    init(horizontalInset: CGFloat, contentSpacing: CGFloat, maxContentSize: CGSize, minimumMultipageWidth: CGFloat) {
        self.horizontalInset = horizontalInset
        self.contentSpacing = contentSpacing
        self.maxContentSize = maxContentSize
        self.minimumMultipageWidth = minimumMultipageWidth
    }

    func scrollViewFrame() -> CGRect {
        return .zero
    }

    func calculateNumberOfPages(for bounds: CGRect) -> Int {
        var numberOfPages = 1

        for n in 2 ... 10000 {
            if contentWidth(numberOfPages: n, in: bounds) < minimumMultipageWidth {
                break
            }
            numberOfPages = n
        }

        return numberOfPages
    }

    func contentWidth(numberOfPages number: Int, in bounds: CGRect) -> CGFloat {
        let totalWidth = bounds.size.width
        let totalSpacings = 2 * horizontalInset + CGFloat(number + 1) * contentSpacing

        let totalAvailableWidth = totalWidth - totalSpacings
        let widthPerContent = totalAvailableWidth / CGFloat(number)

        return widthPerContent
    }
}
