//
//  BGPageControllerLayoutSpecs.swift
//  BuGuaAppTests
//
//  Created by Jeffrey Wu on 2018-09-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

@testable import BuGuaApp
import Nimble
import Quick
import XCTest

class BGPageControllerLayoutSpecs: QuickSpec {
    override func spec() {
        var builder: Builder!

        describe("BGPageControllerLayout") {
            beforeEach {
                builder = Builder()
                builder.inset = 8
                builder.minimumPageSpacing = 16
                builder.maxContentSize = CGSize(width: 500, height: 500)
                builder.minimumMultipageWidth = 488
                builder.totalNumberOfPages = 10
            }

            context("regular iPad size") {
                beforeEach {
                    builder.bounds = CGRect(x: 0, y: 0, width: 1024, height: 740)
                }

                it("right fitting size") {
                    let sut = builder.build()

                    expect(sut.fittingPageSize.width) == 500
                    expect(sut.fittingPageSize.height) == 500
                }

                it("right width for 1 view") {
                    let sut = builder.build()

                    let result = sut.pageWidth(numberOfPages: 1)

                    expect(result) == 976
                }

                it("right width for 2 views") {
                    let sut = builder.build()

                    let result = sut.pageWidth(numberOfPages: 2)

                    expect(result) == 480
                }

                it("should select right page count") {
                    let sut = builder.build()

                    let result = sut.numberOfPagesAtOnce

                    expect(result) == 1
                }

                it("should select right page count just right") {
                    builder.minimumMultipageWidth = 480
                    let sut = builder.build()

                    let result = sut.numberOfPagesAtOnce

                    expect(result) == 2
                }

                context("larger max content size") {
                    beforeEach {
                        builder.maxContentSize = CGSize(width: 2000, height: 2000)
                    }

                    it("right fitting size") {
                        let sut = builder.build()

                        expect(sut.fittingPageSize.width) == 976
                        expect(sut.fittingPageSize.height) == 724
                    }
                }
            }
        }
    }
}

private class Builder {
    var bounds: CGRect = .zero
    var inset: CGFloat = 0
    var minimumPageSpacing: CGFloat = 0
    var maxContentSize: CGSize = .zero
    var minimumMultipageWidth: CGFloat = 0
    var totalNumberOfPages: Int = 1

    func build() -> BGPageControllerLayout {
        return BGPageControllerLayout(bounds: bounds, inset: inset, minimumPageSpacing: minimumPageSpacing, maxContentSize: maxContentSize, minimumMultipageWidth: minimumMultipageWidth, totalNumberOfPages: totalNumberOfPages)
    }
}
