//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by stephen on 8/1/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit

class MemeMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerController = UIImagePickerController()
        pickerController.delegate = self

        
        // Mark: Initialize Delegates
        initDelegates()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.subscribeToKeyboardNotifications()
        shareItem.isEnabled = (imagePickerView?.image != nil)
        
        // Adjust textField sizes
        updateTextField()
        
    }
    
    func updateTextField(){
        TopTextField.sizeToFit()
        BotTextField.sizeToFit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }


    // MARK: Outlet Declaration
    @IBOutlet weak var imagePickerView: UIImageView!

    @IBOutlet weak var pickerButton: UIToolbar!
    @IBOutlet weak var cameraItem: UIBarButtonItem!
    @IBOutlet weak var albumItem: UIBarButtonItem!
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var BotTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareItem: UIBarButtonItem!
    @IBOutlet weak var cancelItem: UIBarButtonItem!
    @IBOutlet weak var outerStackView: UIStackView!
    
    
    var pickerController: UIImagePickerController!
    var memedImage: UIImage? = nil
    
    let TopTextFieldDelegate = DisplayUITextFieldDelegate()
    let BotTextFieldDelegate = DisplayUITextFieldDelegate()
    
    // MARK: function deClaration
    // pick an image from UI
    @IBAction func pickAnImageFromAlbum(){
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    
    // initializes Top/Bot Text Fields
    @IBAction func initTextFieldAttribute(){
        TopTextField.textAlignment = .center
        BotTextField.textAlignment = .center
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name:"Helvetica Neue", size: 40) ??  UIFont.init(),
            NSStrokeWidthAttributeName: 3.0
        ]
                
        
        TopTextField.defaultTextAttributes = memeTextAttributes
        BotTextField.defaultTextAttributes = memeTextAttributes
        
    }
    
    
    func initDelegates(){
        TopTextField.delegate = TopTextFieldDelegate
        BotTextField.delegate = BotTextFieldDelegate
    }
    
    // share the edited Meme UIImage
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        
        let activityC = UIActivityViewController.init(activityItems: [memedImage ?? UIImage()], applicationActivities: [])
        self.present(activityC, animated: true, completion: nil)
        
        //UIActivityType?, Bool, [Any]?, Error?
        
        
        activityC.completionWithItemsHandler = {
            (activity: UIActivityType?, completed: Bool, returnedItems: [Any]?, activityError:Error?) -> Void in
            print("shareMeme: Meme is saved here")
            self.save()
            
            // dimiss the activity view
            activityC.dismiss(animated: true, completion: nil)
            
            // re-draw
            self.outerStackView.setNeedsLayout()
            print("outerStackView update")
        }
        
        

    }


    
    // removes the selected picture
    @IBAction func cancelMeme(){
        imagePickerView.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    // save mem Object
    func save() {
        // Create the meme
        if(memedImage != nil){
            let meme = Meme(topText: TopTextField.text!, bottomText: BotTextField.text!, originalImage: imagePickerView.image!, memedImage: self.memedImage!)
        }
        
        // to be saved to album
    }
}

extension MemeMainViewController{
    
    struct Meme{
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
    }
    
    
    // Render view to an image
    func generateMemedImage() -> UIImage {
         // TODO: Hide toolbar and navbar
        
        // y = view.frame.height + self.pickerButton.frame.height
        // so pickerButton goes out of the view
        pickerButton.frame = CGRect(x:0, y:self.view.frame.height + self.pickerButton.frame.height, width:self.view.frame.size.width, height: self.pickerButton.frame.height)
        
        navigationBar.frame = CGRect(x:0, y:self.view.frame.height + self.navigationBar.frame.height,
                                     width: self.view.frame.size.width, height: self.navigationBar.frame.height)
        
        
        let controller = self.navigationController
        controller?.setNavigationBarHidden(true, animated: true)
        controller?.setToolbarHidden(true, animated: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        pickerButton.frame = CGRect(x:0, y:self.view.frame.height - self.pickerButton.frame.height, width:self.view.frame.size.width, height: self.pickerButton.frame.height)
        
        navigationBar.frame = CGRect(x:0, y:self.view.frame.height - self.navigationBar.frame.height,
                                     width: self.view.frame.size.width, height: self.navigationBar.frame.height)
        
        return memedImage
    }
}


// MARK: Delegation Methods
extension MemeMainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: UIImagePickerControllerDelegate Implmentation
     func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : Any])
     {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imagePickerView.image = image
            imagePickerView.sizeToFit()
            imagePickerView.contentMode = .scaleAspectFit
            
        }
        // need this or imagePickerView.image = image gives an error
        self.dismiss(animated: true, completion: nil)
    }
        
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UINavigationControllerDelegate Implementaion
    
}


// MARK: other necessary methods
extension MemeMainViewController{
    
    func keyboardWillShow(_ notification:Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        if (BotTextField.isEditing && view.frame.origin.y == 0){
            view.frame.origin.y -= keyboardHeight
        }
   
        
    }
    
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    

    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
}
