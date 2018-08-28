//
//  UIView+NibLoadable.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-27.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadable {
    func loadNib()
}

extension NibLoadable where Self: UIView {
    func loadNib() {
        let contentView = Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, options: nil)!.first! as! Self
        self.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
}
