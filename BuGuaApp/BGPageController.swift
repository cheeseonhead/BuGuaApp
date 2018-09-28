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

    var inset = CGFloat(8) {
        didSet { view.setNeedsLayout() }
    }

    var minimumPageSpacing = CGFloat(8) {
        didSet { view.setNeedsLayout() }
    }

    // MARK: - Views

    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView(frame: .zero)

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
        scrollView.addSubview(contentView)

        contentView.addSubviews(viewControllers.map { $0.view })

        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
}

// MARK: - ScrollView

private extension BGPageController {
    func layoutScrollView() {
        let layout = BGPageControllerLayout(bounds: view.bounds,
                                            inset: inset,
                                            minimumPageSpacing: minimumPageSpacing,
                                            maxContentSize: maxSize,
                                            minimumMultipageWidth: minimumMultiPageWidth,
                                            totalNumberOfPages: viewControllers.count)

        scrollView.frame = layout.scrollViewFrame
        scrollView.contentSize = layout.scrollViewContentSize
        contentView.frame = CGRect(origin: .zero, size: layout.scrollViewContentSize)

        zip(viewControllers.map { $0.view }, layout.pageFrames).forEach { view, frame in
            view.frame = frame
        }
    }
}
