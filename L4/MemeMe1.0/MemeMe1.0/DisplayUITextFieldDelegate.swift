//
//  DisplayUITextFieldDelegate.swift
//  MemeMe1.0
//
//  Created by stephen on 8/1/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import UIKit

class DisplayUITextFieldDelegate: NSObject, UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "Top" || textField.text == "Bot"){
            textField.text = ""
        }
    }
}

