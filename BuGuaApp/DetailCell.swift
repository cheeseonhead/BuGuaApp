//
//  DetailCell.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-09-26.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

private enum Style {
    static let masterFont = UIFont.scaled(.body3Medium)
    static let detailFont = UIFont.scaled(.body3)

    static let padding = BGStyle.standardMargin / 2
}

class DetailCell: UITableViewCell {
    // MARK: - Views
    let masterLabel = BodyLabel(frame: .zero)
    let detailLabel = BodyLabel(frame: .zero)

    // MARK: - Appearance
    @objc dynamic var masterLabelWidth = CGFloat(0)

    init(reuseIdentifier: String) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension DetailCell {
    func setup() {
        masterLabel.textAlignment = .right
        masterLabel.font = Style.masterFont

        detailLabel.numberOfLines = 0
        detailLabel.font = Style.detailFont

        contentView.addSubviews([masterLabel, detailLabel])

        masterLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Style.padding)
            make.width.equalTo(DetailCell.appearance().masterLabelWidth)
        }

        detailLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(Style.padding)
            make.leading.equalTo(masterLabel.snp.trailing).offset(Style.padding)
        }
    }
}
