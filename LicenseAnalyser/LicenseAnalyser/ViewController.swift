//
//  ViewController.swift
//  LicenseAnalyser
//
//  Created by Dylan Trachsel on 2016-06-07.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit
import TrueIDMobileSDK

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate {

    @IBOutlet weak var emailLabel: UITextField!
    
    var isChecked = true
    var checked : UIImage = UIImage(named:"ic_check_box_white")!
    var unchecked : UIImage = UIImage(named:"ic_check_box_outline_blank_white")!
    var continue_enable : UIImage = UIImage(named:"confidence-5")!
    var continue_disable : UIImage = UIImage(named:"continue-dark")!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var checkbox: UIButton!
    
    @IBAction func onCheckboxClick(sender: AnyObject) {
        if isChecked {
            checkbox.setImage(checked, forState:.Normal);
            if emailLabel.hasText() {
                continueButton.setImage(continue_enable, forState: .Normal)
                continueButton.enabled = true
            }
            isChecked = false
        }
        else {
            checkbox.setImage(unchecked, forState:.Normal);
            continueButton.setImage(continue_disable, forState: .Normal)
            continueButton.enabled = false
            isChecked = true
            
        }
        
//        self.checkbox.currentImage = UIImage(CGImage: checked)
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func onContinueClick(sender: AnyObject) {
        print(emailLabel.text)
        
        
        self.performSegueWithIdentifier("ConfidenceLevel", sender: self)
    }
    
    @IBOutlet weak var frontPic: UIImageView!
    //take photo part
    var imagePicker: UIImagePickerController!
    
    
    
    @IBAction func addPhoto(sender: AnyObject) {
    }
    
    func imagePickerController(picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        frontPic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    //the photo
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        imagePicker.dismissViewControllerAnimated(true, completion: nil)
//        frontPic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.returnKeyType = UIReturnKeyType.Done
        emailLabel.textColor = UIColor.whiteColor()
        self.continueButton.enabled = false
        emailLabel.layer.borderColor = UIColor(red:33/255.0, green:180/255.0, blue:208/255.0, alpha: 1.0).CGColor
        emailLabel.layer.borderWidth = 1.0
        emailLabel.layer.cornerRadius = 8
        //emailLabel.backgroundColor = UIColor.blackColor()
        emailLabel.layer.masksToBounds = true
        
//        infoLabel.textAlignment = NSTextAlignment.Left
//        infoLabel.text = "Please confirm your approval access to your camera to take picture of your drivers license and yourself for identify purpose."
        infoLabel.font = UIFont(name: "Lato-Regular", size: 15)
//        infoLabel.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(infoLabel)
//
//        view.backgroundColor = UIColor.grayColor()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    
//        for family: String in UIFont.familyNames()
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNamesForFamilyName(family)
//            {
//                print("== \(names)")
//            }
//        }
        
//        checkbox.setImage(unchecked, forState:.Normal);
//        checkbox.setImage(checked, forState:.Highlighted);
//        if (checkbox.state == .Highlighted) {
//            continueButton.setImage(continue_enable, forState: .Normal)
//            
//        }
//        else {
//            
//        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.emailLabel.delegate = self;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        (segue.destinationViewController as! ConfidenceLevelViewController).emailAddress = emailLabel.text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

