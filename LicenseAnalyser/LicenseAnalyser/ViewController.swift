//
//  ViewController.swift
//  LicenseAnalyser
//
//  Created by Dylan Trachsel on 2016-06-07.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit
import TrueIDMobileSDK
import MapKit

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate {

    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var invalidEmailLabel: UILabel!
//    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    var latitude = String()
    var longitude = String()
    
    var isChecked = true
    var checked : UIImage = UIImage(named:"ic_check_box_white")!
    var unchecked : UIImage = UIImage(named:"ic_check_box_outline_blank_white")!
    var continue_enable : UIImage = UIImage(named:"confidence-5")!
    var continue_disable : UIImage = UIImage(named:"continue-dark")!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var checkbox: UIButton!
    
    let locationManager = CLLocationManager()
    
    func locationManagerInit() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func validateEmail(candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
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
        

    }
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func onContinueClick(sender: AnyObject) {
        print(emailLabel.text)
        
        
        self.performSegueWithIdentifier("ConfidenceLevel", sender: self)
    }
    
    @IBOutlet weak var frontPic: UIImageView!
    //take photo part
    var imagePicker: UIImagePickerController!
    
    
    
    func imagePickerController(picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        frontPic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func enableCheckbox () {
        if emailLabel.text == ""{
            checkbox.enabled = false
        }
        else {
            checkbox.enabled = true
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidEmailLabel.hidden = true

        locationManagerInit()

        emailLabel.returnKeyType = UIReturnKeyType.Done
        emailLabel.textColor = UIColor.whiteColor()
        emailLabel.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
    

        self.continueButton.enabled = false
        emailLabel.layer.borderColor = UIColor(red:33/255.0, green:180/255.0, blue:208/255.0, alpha: 1.0).CGColor
        emailLabel.layer.borderWidth = 1.0
        emailLabel.layer.cornerRadius = 8

        emailLabel.layer.masksToBounds = true

        infoLabel.text = "Please confirm your approval for access to your camera to take picture of your drivers license and yourself for identification purposes."
        infoLabel.font = UIFont(name: "Lato-Regular", size: 15)
        
        if emailLabel.text == ""{
            checkbox.enabled = false
        }
        else {
            checkbox.enabled = true
        }
        
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
        enableCheckbox()
        
        if emailLabel.text != nil {
            if !validateEmail(emailLabel.text!) {
                invalidEmailLabel.hidden = false
                checkbox.enabled = false
                
            }
            else {
                checkbox.enabled = true
                invalidEmailLabel.hidden = true
            }
        }
        return false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        enableCheckbox()
        if emailLabel.text != nil {
            if !validateEmail(emailLabel.text!) {
                invalidEmailLabel.hidden = false
                checkbox.enabled = false
                
            }
            else {
                invalidEmailLabel.hidden = true
                checkbox.enabled = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        latitude = String(locValue.latitude)
        longitude = String(locValue.longitude)
        
        LocationData.latitude = latitude
        LocationData.longitude = longitude
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}


