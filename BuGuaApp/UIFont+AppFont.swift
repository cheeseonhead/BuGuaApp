//
//  UIFont+AppFont.swift
//  BuGuaApp
//
//  Created by Jeffrey Wu on 2018-08-29.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

//    PingFangTC-Ultralight
//    PingFangTC-Thin
//    PingFangTC-Light
//    PingFangTC-Regular
//    PingFangTC-Medium
//    PingFangTC-Semibold

    static let appFontRegular = "PingFangTC-Regular"
//    static let appFontRegularItalic = ""
    static let appFontMedium = "PingFangTC-Medium"
//    static let appFontMediumItalic = ""
    static let appFontBold = "PingFangTC-Semibold"
//    static let appFontBoldItalic = ""

    static var headline: UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: 24) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static var title4: UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: 48) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static var title3: UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: 38) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static var title2: UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: 20) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static var title1: UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: 16) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static var subheading: UIFont {
        guard let customFont = UIFont(name: appFontRegular, size: 14) else { fatalError(messageFailedToLoadFont(appFontRegular)) }

        return customFont
    }

    static var body3: UIFont {
        guard let customFont = UIFont(name: appFontRegular, size: 20) else { fatalError(messageFailedToLoadFont(appFontRegular)) }

        return customFont
    }

    static var body3Medium: UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: 20) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static var body2: UIFont {
        guard let customFont = UIFont(name: appFontRegular, size: 16) else { fatalError(messageFailedToLoadFont(appFontRegular)) }

        return customFont
    }

    static var body1: UIFont {
        guard let customFont = UIFont(name: appFontRegular, size: 14) else { fatalError(messageFailedToLoadFont(appFontRegular)) }

        return customFont
    }

    static var body1Medium: UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: 14) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static var caption: UIFont {
        guard let customFont = UIFont(name: appFontRegular, size: 12) else { fatalError(messageFailedToLoadFont(appFontRegular)) }

        return customFont
    }

    static var captionMedium: UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: 12) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static func regularAppFont(size fontSize: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: appFontRegular, size: fontSize) else { fatalError(messageFailedToLoadFont(appFontRegular)) }

        return customFont
    }

    static func mediumAppFont(size fontSize: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: appFontMedium, size: fontSize) else { fatalError(messageFailedToLoadFont(appFontMedium)) }

        return customFont
    }

    static func messageFailedToLoadFont(_ fontName: String) -> String {
        let message =
        """
        Failed to load the "\(fontName)" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """

        return message
    }
}

