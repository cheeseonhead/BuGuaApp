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
    // MARK - Views
    let tableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Input Rx
    let bag = DisposeBag()
    let entryRelay = PublishRelay<BuGuaEntry>()
    
    // MARK: - Private
    var currentEntry: BuGuaEntry? {
        didSet {
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

// MARK: - UITableViewDataSource
extension BuGuaInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MasterDetailCell(reuseIdentifier: "")

        cell.masterLabel.text = "姓名"
        cell.detailLabel.text = "吳孟洋"

        return cell
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

extension AppFactory {
    func makeBuGuaInfoViewController() -> BuGuaInfoViewController {
        return BuGuaInfoViewController()
    }
}
