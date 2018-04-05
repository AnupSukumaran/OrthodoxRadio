//
//  MessageViewController.swift
//  Orthodox Radio
//
//  Created by Sukumar Anup Sukumaran on 08/03/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftValidator
import MessageUI

class MessageViewController: UIViewController, UITextFieldDelegate, ValidationDelegate, MFMailComposeViewControllerDelegate {
   
    
    @IBOutlet weak var NameTF: HoshiTextField!
    @IBOutlet weak var EmailTF: HoshiTextField!
    @IBOutlet weak var FeedBackTF: HoshiTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var sendButtonOL: ButtonExtender!
    
    
    @IBOutlet weak var NameValidateLabel: UILabel!
    
    @IBOutlet weak var EmailValidateLabel: UILabel!
    
    @IBOutlet weak var FeedValidateLabel: UILabel!
    
    
     var activeField: UITextField?
    
    let validator = Validator()
    
    var textFields: [HoshiTextField] = []
    
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isTranslucent = true
        
         self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.scrollView.isScrollEnabled = false
        
        
        textFields = [NameTF, EmailTF, FeedBackTF]
       
        
        for textFieldsSub in textFields {
            textFieldsSub.delegate = self
        }
        
        registerForKeyboardNotifications()
        tapAction() // action on tapping on the screen
        validationMech()
        
    }
    
    
    
    func validationMech() {
        
        validator.styleTransformers(success: { (validationRule) in
            
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            
        }) { (validationError) in
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
        }
        
        validator.registerField(textField: NameTF, errorLabel: NameValidateLabel, rules: [RequiredRule()])
        validator.registerField(textField: EmailTF, errorLabel: EmailValidateLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(textField: FeedBackTF, errorLabel: FeedValidateLabel, rules: [RequiredRule()])
    }
    
    func tapAction() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        print("IAMTOUCHED")
        
         self.view.endEditing(true)
//        for textField123 in textFields {
//            textField123.resignFirstResponder()
//        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
         self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func SendAction(_ sender: Any) {
        
         self.view.endEditing(true)
        validator.validate(delegate: self)

        
    }
    
    func validationSuccessful() {

        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            showMailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        //ajishmmylapra@gmail.com , EmailTF.text!
        mailComposerVC.setToRecipients(["ajishmmylapra@gmail.com"])
    
        mailComposerVC.setSubject("OrthodoxRadio - Feedback - \(NameTF.text!)")
        mailComposerVC.setMessageBody("""
            Name: \(NameTF.text!)
            Email: \(EmailTF.text!)
            
            \(FeedBackTF.text!)
            """, isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Some Error Occured!", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: {
            
           
            switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue :
                print("Cancelled")
                
            case MFMailComposeResult.failed.rawValue :
                print("Failed")
                
            case MFMailComposeResult.saved.rawValue :
                print("Saved")
                
            case MFMailComposeResult.sent.rawValue :
                print("Sent")
                 self.dismiss(animated: true, completion: nil)
                
                
            default: break
                
                
            }
            
            
            
        })
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        print("Validation FAILED!")
    }
    
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification)
    {
        print("DO1234")
        //Need to calculate keyboard exact size due to Apple suggestions
        if FeedBackTF.isEditing {
             self.scrollView.isScrollEnabled = true
        }
        
       
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + sendButtonOL.frame.height + 49, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        
        var aRect : CGRect = self.view.frame

        
        aRect.size.height -= keyboardSize!.height
    
        
        
        if activeField != nil
        {
         
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
                
                
            }
        }
     
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           
                self.scrollView.isScrollEnabled = false
            
        }
        
        
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if FeedBackTF.isEditing {
            self.scrollView.isScrollEnabled = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.scrollView.isScrollEnabled = false
            
        }
        print("Beginging")
        activeField = textField
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        print("EndEditing")
        activeField = nil
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
