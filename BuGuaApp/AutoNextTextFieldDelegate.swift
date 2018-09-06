//
//  AutoNextTextFieldDelegate.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-06.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import RxCocoa
import UIKit

class AutoNextTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    let textFields: [UITextField]
    let finishRelay = PublishRelay<()>()
    
    
    init(textFields: [UITextField]) {
        self.textFields = textFields
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let curIndex = textFields.firstIndex(where: { $0 === textField }), curIndex != textFields.count - 1 {
            textFields[curIndex + 1].becomeFirstResponder()
        } else {
            finishRelay.accept(())
        }
        
        return true
    }
}
