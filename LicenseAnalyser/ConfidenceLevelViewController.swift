//
//  ConfidenceLevelViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-09.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit
import MicroBlink

class ConfidenceLevelViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate, PPScanDelegate {
    var emailAddress = String()
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    var isLocalValid = true
    var isVerXValid = true
    var isPhotoSelected = false
    
    var condifenceScore = String()
    var fraudScore = String()
    var authScore = String()
    
//    let progressIndicatorView = CircularLoaderView(frame: CGRectZero)
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        addSubview(self.progressIndicatorView)
//        progressIndicatorView.frame = bounds
//        progressIndicatorView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
//    }


    @IBAction func button1(sender: AnyObject) {
        self.performSegueWithIdentifier("loading", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        if (isPhotoSelected == false) {
            launchCamera()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
//        self.progressIndicatorView.frame = bounds
//        self.progressIndicatorView.autoresizingMask = .FlexibleWidth | .FlexibleHeight

        // Do any additional setup after loading the view.
    }
    
    func launchCamera() {
        let error: NSErrorPointer = nil
        let coordinator:PPCoordinator?=self.coordinatorWithError(error)
        
        /** If scanning isn't supported, present an error */
        if coordinator == nil {
            let messageString: String = (error.memory?.localizedDescription) ?? ""
            UIAlertView(title: "Warning", message: messageString, delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        
        /** Allocate and present the scanning view controller */
        let scanningViewController: UIViewController = coordinator!.cameraViewControllerWithDelegate(self)
        
        /** You can use other presentation methods as well */
        self.presentViewController(scanningViewController, animated: true, completion: nil)
    }
    
    func finishedLoadingValue() {
        self.performSegueWithIdentifier("loading", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Scanning Delegates
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
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        isPhotoSelected = true
        
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
             
                 var firstName = usdlResult.getField(kPPCustomerFirstName)
                 var lastName = usdlResult.getField(kPPCustomerFamilyName)
                 var fullName = usdlResult.getField(kPPCustomerFullName)
                 
                 var issueDate = usdlResult.getField(kPPDocumentIssueDate)
                 var expireDate = usdlResult.getField(kPPDocumentExpirationDate)
                 
                 var fullAddress = usdlResult.getField(kPPFullAddress)
                 
                 var licenseNo = usdlResult.getField(kPPCustomerIdNumber)
                 licenseNo = licenseNo.stringByReplacingOccurrencesOfString("-", withString: "")
                 
                 let province = usdlResult.getField(kPPAddressJurisdictionCode)
                 
                 let vehicleClass = usdlResult.getField(kPPJurisdictionVehicleClass)
                 
                 
                 // Making DOB format YYYYMMDD
                 var DateOfBirth = usdlResult.getField(kPPDateOfBirth)
                 
                 let index = DateOfBirth.startIndex.advancedBy(4)
                 let year = DateOfBirth.substringFromIndex(index)
                 
                 DateOfBirth = DateOfBirth.stringByReplacingOccurrencesOfString(year, withString: "")
                 DateOfBirth = year + DateOfBirth
                 
                 let person = UserLicense(firstName: firstName, lastName: lastName, fullName: fullName, LicenseIdNumber: usdlResult.getField(kPPCustomerIdNumber), formattedLicense: licenseNo, DateOfBirth: DateOfBirth, ProvinceCode: province, VehicleClass: vehicleClass, expiryDate: expireDate, dateIssued: issueDate, fullAddress: fullName)
                    

                 
                 let streetName = usdlResult.getField(kPPAddressStreet)
                 let city = usdlResult.getField(kPPAddressCity)
                    
                validate(emailAddress, person: person, streetName: streetName, cityName: city)
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func validate(emailAddress : String, person : UserLicense, streetName : String, cityName : String) {
        VerXVerifyLicense(person)
        LocalValidation(person)
        SocialValidation(emailAddress, firstName: person.firstName, lastName: person.lastName)
        AddressVerify("", StreetName: streetName, City: cityName, Province: person.ProvinceCode)
    }
    
    func VerXVerifyLicense(LicenseToVerify: UserLicense) {
        
        let prodUser = "8274851"
        let username = "1648346"
        
        let prodPassword = "xTrbE529V"
        let password = "oFkWR977V"
        
        let prodTokenKey = "WCGKHq1hPPO0uHcQrNfaWw=="
        let TokenKey = "P6Fy2gsO23KuUdvckwLqqA=="
        
        let prodCompanyCode = "13"
        let CompanyCode = "53"
        
        let prodProductCode = "pkkeyprodlazqws12qas"
        let ProductCode = "pkera56g5"
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ver='VerXdirect.API'><soapenv:Header/><soapenv:Body><ver:SingleDL><ver:loginId>"
            + prodUser
            + "</ver:loginId><ver:password>"
            + prodPassword
            + "</ver:password><ver:tokenKey>"
            + prodTokenKey
            + "</ver:tokenKey><ver:version>1.0</ver:version><ver:CompanyCode>"
            + prodCompanyCode
            + "</ver:CompanyCode><ver:PCode>"
            + prodProductCode
            + "</ver:PCode><ver:AccessUID>?</ver:AccessUID><ver:PlaceID>?</ver:PlaceID><ver:TerminalID>?</ver:TerminalID><ver:AssociateID>?</ver:AssociateID><ver:provinceCode>"
            + LicenseToVerify.ProvinceCode
            + "</ver:provinceCode><ver:drivingLicense>"
            + LicenseToVerify.formattedLicense
            + "</ver:drivingLicense><ver:signature>Y</ver:signature><ver:identificationNo></ver:identificationNo><ver:dateOfBirth>"
            + LicenseToVerify.DateOfBirth
            + "</ver:dateOfBirth><ver:licenseClass>"
            + LicenseToVerify.VehicleClass
            + "</ver:licenseClass><ver:reference>?</ver:reference></ver:SingleDL></soapenv:Body></soapenv:Envelope>"
        
        let urlString = "https://www.dlvcheck.com/vxdcustomerapi/CustomerService.asmx"
        //let urlString = "https://vxdtech.com/vxdcustomerapi/CustomerService.asmx"
        
        let url = NSURL(string: urlString)
        
        let theRequest = NSMutableURLRequest(URL: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.setValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        
        theRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithRequest(theRequest, completionHandler: {(data: NSData?, response: NSURLResponse?, error : NSError?) -> Void in
            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            
            let xmlParser = NSXMLParser(data: data!)
            xmlParser.delegate = self
            xmlParser.parse()
            xmlParser.shouldResolveExternalEntities = true
        })
        
        dataTask.resume()
        
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        if (string == "ResultArgument  Name=\"Status\" Value=\"Valid\" /") {
            // LICENSE IS VALID
            print("SUCCESS")
            isVerXValid = true
        }
        else if (string == "ResultArgument  Name=\"Status\" Value=\"Not Found\" /") {
            isVerXValid = false
        }
    }

    // MARK - Validation
    func LocalValidation(LicenseToValidate: UserLicense) {
        // License should be 15 characters long
        if (LicenseToValidate.formattedLicense.characters.count != 15) {
            // INVALID
            isLocalValid = false
        }
        
        // First letter of license is the first letter of last name
        let index = LicenseToValidate.LicenseIdNumber.startIndex
        let firstLicense = LicenseToValidate.LicenseIdNumber[index]
        let firstOfLastName = LicenseToValidate.lastName[index]
        
        if (firstLicense != firstOfLastName) {
            // INVALID
            isLocalValid = false
        }
        
        // Characters 12-15 of License are Birth MMDD
        let lastFourLicense = LicenseToValidate.formattedLicense.substringWithRange(Range<String.Index>(start: LicenseToValidate.formattedLicense.startIndex.advancedBy(11), end: LicenseToValidate.formattedLicense.endIndex))
        
        let lastFourDOB = LicenseToValidate.DateOfBirth.substringWithRange(Range<String.Index>(start: LicenseToValidate.DateOfBirth.startIndex.advancedBy(4), end: LicenseToValidate.DateOfBirth.endIndex))
        
        if (lastFourLicense != lastFourDOB) {
            isLocalValid = false
        }
        
        
        let lastTwoYearDOB = LicenseToValidate.DateOfBirth.substringWithRange(Range<String.Index>(start: LicenseToValidate.DateOfBirth.startIndex.advancedBy(2), end: LicenseToValidate.DateOfBirth.startIndex.advancedBy(4)))
        
        let lastTwoYearLicense = LicenseToValidate.formattedLicense.substringWithRange(Range<String.Index>(start: LicenseToValidate.formattedLicense.startIndex.advancedBy(9), end: LicenseToValidate.formattedLicense.startIndex.advancedBy(11)))
        
        if (lastTwoYearDOB != lastTwoYearLicense) {
            isLocalValid = false
        }
        
        
        let currentDate = NSDate()
        
        let dateString = LicenseToValidate.expiryDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        let expDate = dateFormatter.dateFromString(dateString)
        
        if (currentDate.compare(expDate!) == NSComparisonResult.OrderedDescending) {
            isLocalValid = false
        }
    }
    
    // MARK Social Validation
    func SocialValidation(email : String, firstName : String, lastName : String) {
        var url : String = "https://service.socure.com/api/2.5/EmailAuthScore?socurekey=7ed058ad-d6bb-4f1a-ba4f-28ffbcf5eafc&email="
            + email
            + "&firstname="
            + firstName
            + "&surname="
            + lastName
            + "&country=CA"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                if (data != nil) {
                    let jsonResult: NSObject! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSObject
                    if (jsonResult != nil) {
                        let preScore = jsonResult.valueForKey("data")
                        self.condifenceScore = String(Double((preScore?.valueForKey("confidence"))! as! NSNumber))
                        self.fraudScore = String(Double((preScore?.valueForKey("fraudscore"))! as! NSNumber))
                        self.authScore = String(Double((preScore?.valueForKey("authscore"))! as! NSNumber))
                    } else {
                        // couldn't load JSON, look at error
                    }
                }
            }
            catch {
                print(error)
            }
        })
    }
    
    func AddressVerify(StreetNum : String, StreetName : String, City : String, Province : String) {
        var url : String = "http://geocoder.ca/?stno="
            + StreetNum
            + "&adresst="
            + StreetName
            + "&city="
            + City
            + "&prov="
            + Province
            + "&postal="
            + "&id="
            + "&geoit=XML"
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                if (data != nil) {
                    var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                }
                // enhanced - 100 or 0 from postal code
                // gov - valid or not 100 or 0
                // social - 10 == 25, 0 == 0
            }
            catch {
                print(error)
            }
        })
    }
    


}
