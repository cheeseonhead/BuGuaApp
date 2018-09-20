//
//  Theme.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-19.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

enum Theme {
    case light
    
    var bodyText: UIColor {
        switch self {
        case .light: return .spaceGrey
        }
    }
    
    var tint: UIColor {
        switch self {
        case .light: return .mars
        }
    }
    
    var background: UIColor {
        switch self {
        case .light: return .baige
        }
    }
    
    var navigationBarTint: UIColor {
        switch self {
        case .light: return .white
        }
    }
    
    var navigationBarStyle: UIBarStyle {
        switch self {
        case .light: return .default
        }
    }
}
