//
//  ComposableTextfieldDelegate.swift
//  BuGuaApp
//
//  Created by Cheese Onhead on 2018-09-06.
//  Copyright © 2018 Jeffrey Wu. All rights reserved.
//

import Foundation
import UIKit

class ComposedTextFieldDelegate: NSObject, UITextFieldDelegate {
    let textFieldDelegates: [UITextFieldDelegate]
    let composeMethod: (Bool, @autoclosure () -> Bool) throws -> Bool
    
    init(delegates: [UITextFieldDelegate], _ composeMethod: @escaping (Bool, @autoclosure () -> Bool) throws -> Bool ) {
        self.textFieldDelegates = delegates
        self.composeMethod = composeMethod
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textFieldDelegates.reduce(true) { res, delegate in
            guard let curRes = delegate.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) else { return res }
            return try! composeMethod(res, curRes)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textFieldDelegates.reduce(true) { res, delegate in
            guard let curRes = delegate.textFieldShouldReturn?(textField) else { return res }
            return try! composeMethod(res, curRes)
        }
    }
}
