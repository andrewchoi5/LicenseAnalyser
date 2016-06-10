//
//  ViewController.swift
//  LicenseAnalyser
//
//  Created by Dylan Trachsel on 2016-06-07.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PPScanDelegate, UITextFieldDelegate {
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
        self.performSegueWithIdentifier("ConfidenceLevel", sender: self)
    }
    
    @IBOutlet weak var frontPic: UIImageView!
    //take photo part
    var imagePicker: UIImagePickerController!
    
    
    func coordinatorWithError(error: NSErrorPointer) -> PPCoordinator? {
        
        if (PPCoordinator.isScanningUnsupportedForCameraType(PPCameraType.Back, error: error)) {
            return nil;
        }

        let settings: PPSettings = PPSettings()
        settings.licenseSettings.licenseKey = "GJJJYNG5-ST2WF7M3-7XLLOKB2-GK3VAWUZ-I23CQORS-W5IFVGKG-WYUDUMVW-EBS4PA2R"
        let mrtdRecognizerSettings = PPMrtdRecognizerSettings()

        settings.scanSettings.addRecognizerSettings(mrtdRecognizerSettings)
        
        let usdlRecognizerSettings = PPUsdlRecognizerSettings()
        
        settings.scanSettings.addRecognizerSettings(usdlRecognizerSettings)
        
        let coordinator: PPCoordinator = PPCoordinator(settings: settings)

        return coordinator
    }
    
    @IBAction func addPhoto(sender: AnyObject) {
        let error: NSErrorPointer = nil
        let coordinator:PPCoordinator?=self.coordinatorWithError(error)
        
        /** If scanning isn't supported, present an error */
        if coordinator == nil {
            let messageString: String = (error.memory?.localizedDescription) ?? ""
            UIAlertView(title: "Warning", message: messageString, delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        //the whole photo thing
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        
        //
        
        /** Allocate and present the scanning view controller */
        let scanningViewController: UIViewController = coordinator!.cameraViewControllerWithDelegate(self)
//        scanningViewController.
        
        /** You can use other presentation methods as well */
        self.presentViewController(scanningViewController, animated: true, completion: nil)
        print("ARRIVED AT THE OTHER VIEW/n")
        self.presentViewController(imagePicker, animated: true, completion: nil)
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
    
    
    
    func scanningViewControllerUnauthorizedCamera(scanningViewController: UIViewController) {
        // Add any logic which handles UI when app user doesn't allow usage of the phone's camera
    }
    
    func scanningViewController(scanningViewController: UIViewController, didFindError error: NSError) {
        // Can be ignored. See description of the method
    }
    
    func scanningViewControllerDidClose(scanningViewController: UIViewController) {
        // As scanning view controller is presented full screen and modally, dismiss it
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scanningViewController(scanningViewController: UIViewController?, didOutputResults results: [PPRecognizerResult]) {
        
        let scanConroller : PPScanningViewController = scanningViewController as! PPScanningViewController
        
        // Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
        
        // first, pause scanning until we process all the results
        scanConroller.pauseScanning()
        
        var message : String = ""
        var title : String = ""
        
        // Collect data from the result
        for result in results {
            if(result.isKindOfClass(PPMrtdRecognizerResult)) {
                let mrtdResult : PPMrtdRecognizerResult = result as! PPMrtdRecognizerResult
                title="MRTD"
                message=mrtdResult.description
            }
            if(result.isKindOfClass(PPUsdlRecognizerResult)) {
                let usdlResult : PPUsdlRecognizerResult = result as! PPUsdlRecognizerResult
                title="USDL"
                message=usdlResult.description
                print("RESULTS")
                print(usdlResult.getField(kPPCustomerIdNumber))
                print(usdlResult.getField(kPPDateOfBirth))
                print(usdlResult.getField(kPPAddressJurisdictionCode))
                print(usdlResult.getField(kPPJurisdictionVehicleClass))
            }
        }

        //present the alert view with scanned results
        let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
        //print(message)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func Verify(sender: AnyObject) {
        SOAPInterface.VerifyCard()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.continueButton.enabled = false
        
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

