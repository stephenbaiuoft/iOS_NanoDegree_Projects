//
//  dollarSignDelegate.swift
//  Bai_textFieldChallengeApp
//
//  Created by stephen on 7/31/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import UIKit

class DollarSignTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // Asks the delegate if the specified text should be changed.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        var newText = textField.text! as String
       
        var resultText = ""
        //$00.00
        
        
        if (string != "" ){
            if( (Int(string) == nil)){
                // sanity check
                print("sanity check for input")
                return false
            }
        }
        
//        if(newText.characters.count  <= 5 && string == "" ){
//            textField.text = "$0.00"
//            // not allowing to edit
//            return false
//        }

            
        let strAry = newText.components(separatedBy: ".")
        if (strAry.count == 2){
            var first = strAry[0]
            var second = strAry[1]
            
            // delete
            if ( string == "" ){
                // 98.76 --> shift left --> 9.87
                let removal = String(first.characters.removeLast())
                if (first.characters.count == 1){
                    first = "$0"
                }
                second.characters.removeLast()
                resultText = first + "." + removal + second
            }
            // adding character
            else{
                let shift = String(second.characters.removeFirst())
                if first == "$0"{
                    first = "$"
                }
                resultText = first + shift + "." + second + string
                
            }
            
        }
        
        else{
            textField.text = "Error Encoutered"
            print("Error Encoutered")
            
        }
        
        
        textField.text = resultText
        return false

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    
}
