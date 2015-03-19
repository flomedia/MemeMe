//
//  ViewController.swift
//  MemeMe
//
//  Created by Florin Tudose on 12.03.15.
//  Copyright (c) 2015 FLO Media. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var memeNavBar: UINavigationBar!
    
    @IBOutlet weak var memeToolBar: UIToolbar!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    var user_has_entered_top: Bool!
    var user_has_entered_bottom: Bool!
    var current_edited_field: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
       override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topText.text = "TOP"
        topText.textAlignment = NSTextAlignment.Center
        topText.delegate = self
        user_has_entered_top = false
        topText.defaultTextAttributes = memeTextAttributes
        topText.sizeToFit()

        topText.frame = CGRectMake(topText.frame.origin.x, topText.frame.origin.y, self.view.frame.width-20, topText.frame.height)
        
        bottomText.text = "BOTTOM"
        bottomText.textAlignment =  NSTextAlignment.Center
        bottomText.delegate = self
        user_has_entered_bottom = false
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.sizeToFit()
        
        bottomText.frame = CGRectMake(bottomText.frame.origin.x, bottomText.frame.origin.y, self.view.frame.width-20, bottomText.frame.height)
        
        shareButton.enabled = false

        
    }


    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable    (UIImagePickerControllerSourceType.Camera)
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
       
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if current_edited_field == bottomText {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if current_edited_field == bottomText {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return keyboardSize.CGRectValue().height
    }
    
    





    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" && !user_has_entered_top{
            textField.text = ""
            user_has_entered_top = true
        }
        else if textField.text == "BOTTOM" && !user_has_entered_bottom{
            textField.text = ""
            user_has_entered_bottom = true
        }
        current_edited_field = textField
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == topText && textField.text == "" {
            textField.text = "TOP"
            user_has_entered_top = false
        }
        else if textField == bottomText && textField.text == "" {
            textField.text = "BOTTOM"
            user_has_entered_bottom = false
        }
        else{
            shareButton.enabled = true
        }
        return true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        imagePickerView.image = image
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        shareButton.enabled = true
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
        shareButton.enabled = true

    }

    @IBAction func shareMeme(sender: AnyObject) {
        
        saveMeme()
        
        let objectsToShare = [generateMemedImage()]
        
        
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = activityCompletionHandler
        self.presentViewController(activityVC, animated: true, completion: nil)
        
       
     
    }
    
    func activityCompletionHandler(activityType: String!,
        completed: Bool,
        returneditems: [AnyObject]!,
        activityError: NSError!){
            if completed && activityError == nil{
                var tabBarController:UITabBarController
                tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("SavedMemesViewTabBarController") as UITabBarController
                self.presentViewController(tabBarController, animated: true, completion: nil)
                
            }
    }
    func saveMeme()
    {
        var meme = Meme(topText: topText.text, bottomText: bottomText.text, image: imagePickerView.image!, memedImage: generateMemedImage())
        
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        appDelegate.memes.append(meme)

    }
    func generateMemedImage() -> UIImage {
        
        memeNavBar.hidden = true
        memeToolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        memeNavBar.hidden = false
        memeToolBar.hidden = false
        
        return memedImage
    }
    


}

