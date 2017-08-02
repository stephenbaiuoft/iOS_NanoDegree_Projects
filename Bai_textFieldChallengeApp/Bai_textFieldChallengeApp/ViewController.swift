//
//  ViewController.swift
//  Bai_textFieldChallengeApp
//
//  Created by stephen on 7/31/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        zipCodeTextField.delegate = zipCodeDelegate
        dollarSignTextField.delegate = dollarSignDelegate
        dollarSignTextField.text = "$0.00"
        toggleTextField.delegate = self
        switchButton.isOn = false
    }

    

    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var dollarSignTextField: UITextField!
    @IBOutlet weak var toggleTextField: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    
    let zipCodeDelegate = ZipCodeTextFieldDelegate()
    let dollarSignDelegate = DollarSignTextFieldDelegate()
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if switchButton.isOn{
            return true
        }
        return false
    }
    
    // automatically dismiss keyboard 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    

}

