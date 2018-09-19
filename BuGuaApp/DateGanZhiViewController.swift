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
    private let styler: AppStyler
    private let factory: AppFactory

    // MARK; - Init
    init(factory: AppFactory, styler: AppStyler, viewModel: DateGanZhiViewModel) {
        self.styler = styler
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
        styler.navigationTitlize(titleLabel)
        navigationItem.titleView = titleLabel

        finishBarButton = UIBarButtonItem(title: NSLocalizedString("完成", comment: ""),
                                          style: .done, target: nil, action: nil)
        styler.navigationBarItemize(finishBarButton)
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
        ganZhiPreviewLabel.font = .title2
        styler.appColorize(ganZhiPreviewLabel)
        styler.appThemize(view)
    }
}

// MARK: - Bindings
private extension DateGanZhiViewController {
    func bindings() {
        previewLabelBinding()
        
        viewModel.previewDriver.asObservable().filterMap {
            switch $0 {
            case .next: return .map(true)
            case .error: return .map(false)
            default: return .ignore
            }
        }.bind(to: finishBarButton.rx.isEnabled)
        .disposed(by: bag)
        
        dateInputViewController.viewModel.gregorianDateDriver
            .drive(viewModel.gregorianDateRelay)
            .disposed(by: bag)
        
        finishBarButton.rx.tap
            .bind(to: viewModel.finishRelay)
            .disposed(by: bag)
    }
    
    func previewLabelBinding() {
        viewModel.previewDriver.asObservable().stringify(String.init)
            .bind(to: ganZhiPreviewLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.previewDriver.map { [unowned self] in self.previewLabelColor($0) }
            .drive(ganZhiPreviewLabel.rx.textColor)
            .disposed(by: bag)
    }
    
    func previewLabelColor(_ event: Event<String>) -> UIColor {
        switch event {
        case .next: return .spaceGrey
        case .error: return .scarlet
        default: return .spaceGrey
        }
    }
}

extension AppFactory {
    func makeDateGanZhiViewController(viewModel: DateGanZhiViewModel) -> DateGanZhiViewController {
        return DateGanZhiViewController(factory: self, styler: styler, viewModel: viewModel)
    }
}

private extension Reactive where Base == UILabel {
    var textColor: Binder<UIColor> {
        return Binder(self.base) { label, color in
            label.textColor = color
        }
    }
}
