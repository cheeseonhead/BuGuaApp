//
//  DateGanZhiViewController.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-16.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import SnapKit
import UIKit

class DateGanZhiViewController: UIViewController {

    // MARK: - Views
    @IBOutlet var dateInputHolder: UIView!
    @IBOutlet var ganZhiPreviewLabel: UILabel!
    var titleLabel: UILabel!
    var finishBarButton: UIBarButtonItem!

    // MARK: - Child VCs
    var dateInputViewController: DateInputViewController!

    // MARK - Public Properties
    let bag = DisposeBag()
    let viewModel: DateGanZhiViewModel

    // MARK: - Private
    private let factory: AppFactory

    // MARK; - Init
    init(factory: AppFactory, viewModel: DateGanZhiViewModel) {
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        creation()
        styling()
        bindings()
    }
}

// MARK: - Setup
private extension DateGanZhiViewController {
    func creation() {
        createDateInput()

        titleLabel = UILabel(frame: .zero)
        titleLabel.text = NSLocalizedString("輸入日期", comment: "")
        navigationItem.titleView = titleLabel

        finishBarButton = UIBarButtonItem(title: NSLocalizedString("完成", comment: ""),
                                          style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = finishBarButton
    }

    func createDateInput() {
        let viewModel = factory.makeDateInputViewModel()
        dateInputViewController = factory.makeDateInputViewController(viewModel: viewModel)

        addChild(dateInputViewController)
        dateInputHolder.addSubview(dateInputViewController.view)
        dateInputViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dateInputViewController.didMove(toParent: self)
    }

    func styling() {
        titleLabel.font = .title1
        titleLabel.textColor = .spaceGrey

        ganZhiPreviewLabel.font = .title2
        ganZhiPreviewLabel.textColor = .spaceGrey
    }

    func bindings() {
        viewModel.previewDriver.asObservable().elements()
            .bind(to: ganZhiPreviewLabel.rx.text)
            .disposed(by: bag)

        viewModel.previewDriver.asObservable().errors()
            .map { $0.localizedDescription }
            .bind(to: ganZhiPreviewLabel.rx.text)
            .disposed(by: bag)

        viewModel.previewDriver.map { event -> UIColor in
            switch event {
            case .next: return .spaceGrey
            case .error: return .scarlet
            default: return .spaceGrey
            }
        }.drive(ganZhiPreviewLabel.rx.textColor)
        .disposed(by: bag)

        dateInputViewController.viewModel.gregorianDateDriver
            .drive(viewModel.gregorianDateRelay)
            .disposed(by: bag)
    }
}

extension AppFactory {
    func makeDateGanZhiViewController(viewModel: DateGanZhiViewModel) -> DateGanZhiViewController {
        return DateGanZhiViewController(factory: self, viewModel: viewModel)
    }
}

private extension Reactive where Base == UILabel {
    var textColor: Binder<UIColor> {
        return Binder(self.base) { label, color in
            label.textColor = color
        }
    }
}
