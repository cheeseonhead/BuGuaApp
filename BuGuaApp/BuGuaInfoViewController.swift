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
    let tableView = UITableView(frame: .zero)
    
    // MARK: - Input Rx
    let bag = DisposeBag()
    let entryRelay = PublishRelay<BuGuaEntry>()
    
    // MARK: - Private
    var currentEntry: BuGuaEntry?
    
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
        let cell = UITableViewCell(style: ., reuseIdentifier: <#T##String?#>)
        
    }

    
}

// MARK: - Setup
private extension BuGuaInfoViewController {
    func setup() {
        createViews()
        binding()
        styling()
    }
    
    func createViews() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SingleLineCell")
        tableView.dataSource = self
        tableView.delegate = self
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
