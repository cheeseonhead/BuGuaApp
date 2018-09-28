//
//  BGPageController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-26.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit

class BGPageController: UIViewController {

    // MARK: - Config

    /// This is the minimum page width when more than one page is going to fit on the screen. It is ignored when
    /// only one page can fit.
    var minimumMultiPageWidth = CGFloat(0) {
        didSet { view.setNeedsLayout() }
    }

    /// The maximum of either dimension for a page. This prevents the page from growing too big on larger screens.
    var maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude) {
        didSet { view.setNeedsLayout() }
    }

    /// This is used for insetting the top and bottom of the pages. As well as deciding how much of the next page to
    /// "peek" out
    var inset = CGFloat(8) {
        didSet { view.setNeedsLayout() }
    }

    /// The minimum amount of spacing between two pages
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

        viewControllers.forEach { vc in
            addChild(vc)
        }

        contentView.addSubviews(viewControllers.map { $0.view })

        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        view.addGestureRecognizer(scrollView.panGestureRecognizer)
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
