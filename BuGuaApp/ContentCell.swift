//
//  ContentCell.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-26.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import UIKit

private enum Style {
    static let font = UIFont.scaled(.body2)
}

class ContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: BodyLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }
}

// MARK: - Setup
private extension ContentCell {
    func setup() {
        contentLabel.font = Style.font
    }
}
