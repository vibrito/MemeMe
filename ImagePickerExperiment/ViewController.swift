//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Vinicius Brito on 9/2/15.
//  Copyright (c) 2015 Vinicius. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet weak var imageViewPicker: UIImageView!
    @IBOutlet weak var textFieldUp: UITextField!
    @IBOutlet weak var textFieldDown: UITextField!
    
    @IBOutlet weak var buttonCamera: UIBarButtonItem!
    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    
    @IBOutlet weak var toolBarUp: UIToolbar!
    @IBOutlet weak var toolBarDown: UIToolbar!
    
    var isTextFieldDown = false
    var floatViewRect : Float = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName     : UIColor .whiteColor(),
            NSForegroundColorAttributeName : UIColor .blackColor(),
            NSBackgroundColorAttributeName : UIColor .clearColor(),
            NSFontAttributeName            : UIFont(name:"HelveticaNeue-CondensedBlack", size: 30)!,
            NSStrokeWidthAttributeName     : -4.0
        ]
        
        textFieldUp.borderStyle = UITextBorderStyle.RoundedRect
        textFieldDown.borderStyle = UITextBorderStyle.RoundedRect
        
        textFieldUp.defaultTextAttributes   = memeTextAttributes
        textFieldUp.textAlignment           = NSTextAlignment.Center
        textFieldDown.defaultTextAttributes = memeTextAttributes
        textFieldDown.textAlignment         = NSTextAlignment.Center
    }
    
    override func viewWillAppear(animated: Bool)
    {
        buttonCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        buttonShare.enabled = false
        buttonCancel.enabled = false
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func generateMemedImage() -> UIImage
    {
        toolBarDown.hidden = true
        toolBarUp.hidden = true
        
        textFieldUp.borderStyle = UITextBorderStyle.None
        textFieldDown.borderStyle = UITextBorderStyle.None
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBarUp.hidden = false
        toolBarDown.hidden = false
        
        textFieldUp.borderStyle = UITextBorderStyle.RoundedRect
        textFieldDown.borderStyle = UITextBorderStyle.RoundedRect
        
        return memedImage
    }
    
    @IBAction func actionShare(sender: UIBarButtonItem)
    {
        let objectsToShare = [generateMemedImage()]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func actionCancel(sender: UIBarButtonItem)
    {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure about clean the screen?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            print("Apagar")
            self.textFieldDown.text = ""
            self.textFieldUp.text = ""
            self.imageViewPicker.image = nil
            self.buttonCancel.enabled = false
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    @IBAction func actionPickAnImageFromLibrary (sender: AnyObject)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func actionPickAnImageFromCamera (sender: AnyObject)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
            self.imageViewPicker.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if  textField == self.textFieldDown
        {
            isTextFieldDown = true
        }
    }
    
//    func textFieldDidEndEditing(textField: UITextField)
//    {
//        if  textField == self.textFieldDown
//        {
//            isTextFieldDown = false
//        }
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textFieldUp.resignFirstResponder()
        textFieldDown.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if isTextFieldDown
        {
            self.view.frame.origin.y += getKeyboardHeight(notification)
            isTextFieldDown = false
        }
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        floatViewRect = Float(self.view.frame.origin.y)
        if isTextFieldDown
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
}

