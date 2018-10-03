//
//  BuGuaInfoViewController.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-24.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import BuGuaKit
import Foundation
import RxCocoa
import RxSwift
import UIKit

class BuGuaInfoViewController: UIViewController {
    enum ContentType {
        case name, timeStamp, question, notes

        var masterText: String {
            switch self {
            case .name: return NSLocalizedString("姓名", comment: "")
            case .timeStamp: return NSLocalizedString("日期", comment: "")
            case .question: return NSLocalizedString("問事", comment: "")
            default: return ""
            }
        }
    }

    // MARK: - Views

    let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Input Rx

    let bag = DisposeBag()
    let entryRelay = PublishRelay<BuGuaEntry>()

    // MARK: - Private Constants

    let masterDetailIdentifier = "masterDetailCell"
    let contentIdentifier = "contentIdentifier"

    // MARK: - Private

    let factory: AppFactory
    var currentEntry: BuGuaEntry? {
        didSet {
            tableView.reloadData()
        }
    }

    init(factory: AppFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - UITableViewDataSource

extension BuGuaInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDetailRow(indexPath) {
            let contentType = detailType(for: indexPath.row)

            let cell = MasterDetailCell(reuseIdentifier: masterDetailIdentifier)

            cell.masterLabel.text = contentType.masterText

            guard let currentEntry = currentEntry else { return cell }

            switch contentType {
            case .name:
//                cell.detailLabel.text = currentEntry.name
                cell.detailLabel.text = "尚未完工"
            case .timeStamp:
                cell.detailLabel.text = formatDate(currentEntry.date, time: currentEntry.time)
            case .question:
//                cell.detailLabel.text = currentEntry.question
                cell.detailLabel.text = "尚未完工"
            default: fatalError()
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: contentIdentifier) as! ContentCell

//            guard let currentEntry = currentEntry else { return cell }

            cell.contentLabel.text = "尚未完工"
//            cell.contentLabel.text = currentEntry.notes

            return cell
        }
    }

    func isDetailRow(_ indexPath: IndexPath) -> Bool {
        return indexPath.row <= 2
    }

    func detailType(for row: Int) -> ContentType {
        switch row {
        case 0: return .name
        case 1: return .timeStamp
        case 2: return .question
        default: fatalError()
        }
    }
}

// MARK: - Setup

private extension BuGuaInfoViewController {
    func setup() {
        createViews()
        constraints()
        binding()
        styling()
    }

    func createViews() {
        let cardView = CardBackground(frame: .zero)
        view = cardView

        let inset = cardView.cornerRadius
        additionalSafeAreaInsets = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.insetsContentViewsToSafeArea = true
        tableView.register(ContentCell.nib(), forCellReuseIdentifier: contentIdentifier)

        view.addSubview(tableView)
    }

    func constraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func binding() {
        entryRelay.bind(onNext: { [unowned self] entry in
            self.currentEntry = entry
        }).disposed(by: bag)
    }

    func styling() {
    }
}

// MARK: - Helpers

private extension BuGuaInfoViewController {
    func formatDate(_ date: GregorianDate, time: GregorianTime) -> String {
        let formatter = factory.makeGregorianFormatter(dateStyle: .medium, timeStyle: .short)

        return formatter.formatGregorianDate(date, time: time)
    }
}

extension AppFactory {
    func makeBuGuaInfoViewController() -> BuGuaInfoViewController {
        return BuGuaInfoViewController(factory: self)
    }
}
