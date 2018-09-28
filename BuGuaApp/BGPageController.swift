//
//  BGPageController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-26.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit

private enum Style {
    static let contentSpacing = BGStyle.standardMargin / 2
    static let horizontalContentInset = contentSpacing
}

class BGPageController: UIViewController {

    // MARK: - Config

    var minimumMultiPageWidth = CGFloat(0) {
        didSet { view.setNeedsLayout() }
    }

    var maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude) {
        didSet { view.setNeedsLayout() }
    }

    var contentRatio = CGFloat(1) {
        didSet { view.setNeedsLayout() }
    }

    // MARK: - Views

    let scrollView = UIScrollView(frame: .zero)

    // MARK: - Properties

    let viewControllers: [UIViewController]

    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        viewControllers = []

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutScrollView()
    }
}

// MARK: - Setup

private extension BGPageController {
    func setup() {
        view.addSubview(scrollView)
    }
}

// MARK: - ScrollView

private extension BGPageController {
    func layoutScrollView() {
        let layout = BGPageControllerLayout(bounds: view.bounds,
                                            horizontalInset: Style.horizontalContentInset,
                                            contentSpacing: Style.contentSpacing,
                                            maxContentSize: maxSize,
                                            minimumMultipageWidth: minimumMultiPageWidth)

        scrollView.frame = layout.scrollViewFrame()
    }
}
