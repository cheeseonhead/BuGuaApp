//
//  UITableViewCell+Nib.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-30.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static func nib() -> UINib {

        let nibName = String(describing: self)

        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
}
