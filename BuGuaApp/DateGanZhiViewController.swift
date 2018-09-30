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
    @IBOutlet var ganZhiPreviewLabel: BodyLabel!
    var finishBarButton: UIBarButtonItem!

    // MARK: - Child VCs
    var dateInputViewController: DatePickerViewController!

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
        
        navigationItem.title = NSLocalizedString("輸入日期", comment: "")

        finishBarButton = UIBarButtonItem(title: NSLocalizedString("下一個", comment: ""),
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
        ganZhiPreviewLabel.font = .scaled(.title2)
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
        
        viewModel.previewDriver.map(DateGanZhiViewController.previewLabelColor)
            .drive(ganZhiPreviewLabel.rx.textColor)
            .disposed(by: bag)
    }
    
    static func previewLabelColor(_ event: Event<String>) -> UIColor? {
        switch event {
        case .next: return BodyLabel.appearance().textColor
        case .error: return .scarlet
        default: return BodyLabel.appearance().textColor
        }
    }
}

extension AppFactory {
    func makeDateGanZhiViewController(viewModel: DateGanZhiViewModel) -> DateGanZhiViewController {
        return DateGanZhiViewController(factory: self, viewModel: viewModel)
    }
}

private extension Reactive where Base: UILabel {
    var textColor: Binder<UIColor?> {
        return Binder(self.base) { label, color in
            label.textColor = color
        }
    }
}
