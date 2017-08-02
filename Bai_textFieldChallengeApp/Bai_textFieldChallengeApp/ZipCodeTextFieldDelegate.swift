//
//  zipCodeDelegate.swift
//  Bai_textFieldChallengeApp
//
//  Created by stephen on 7/31/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import UIKit

class ZipCodeTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let newText = textField.text! as NSString
        if (newText.length == 5 && string.characters.count != 0){
            return false
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
