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

    var minSize = CGSize.zero {
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
    }
}

// MARK: - Setup

private extension BGPageController {
    func setup() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
    }
}
