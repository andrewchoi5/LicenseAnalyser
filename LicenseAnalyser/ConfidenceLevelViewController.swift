//
//  ConfidenceLevelViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-09.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit
import MicroBlink
import MapKit

class ConfidenceLevelViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate, PPScanDelegate {
    
    var latitude = String()
    var longitude = String()

    var emailAddress = String()
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    var isLocalValid = false
    var isVerXValid = false
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
    let locationManager = CLLocationManager()
    
    func locationManagerInit() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

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
        locationManagerInit()
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
        isPhotoSelected = true
        
        
        scanningViewController?.dismissViewControllerAnimated(false, completion: nil)
        
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
                 

                    

                 
                 let streetName = usdlResult.getField(kPPAddressStreet)
                 let city = usdlResult.getField(kPPAddressCity)
                
                let person = UserLicense(firstName: firstName, lastName: lastName, fullName: fullName, LicenseIdNumber: usdlResult.getField(kPPCustomerIdNumber), formattedLicense: licenseNo, DateOfBirth: DateOfBirth, ProvinceCode: province, VehicleClass: vehicleClass, expiryDate: expireDate, dateIssued: issueDate, fullAddress: fullName, emailAddress: emailAddress, streetName: streetName, city: city)
                
                
                 validate(person)
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func validate(personToVerify : UserLicense) {
        //VerXVerifyLicense(personToVerify)
        //LocalValidation(personToVerify)
        //SocialValidation(personToVerify.emailAddress, firstName: personToVerify.firstName, lastName: personToVerify.lastName)
        //AddressVerify("", StreetName: personToVerify.streetName, City: personToVerify.city, Province: personToVerify.ProvinceCode)
        
        VerXVerifyLicense(personToVerify)
    }
    
    func VerXVerifyLicense(LicenseToVerify: UserLicense) {
        print("VerX called")
        
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
            + username
            + "</ver:loginId><ver:password>"
            + password
            + "</ver:password><ver:tokenKey>"
            + TokenKey
            + "</ver:tokenKey><ver:version>1.0</ver:version><ver:CompanyCode>"
            + CompanyCode
            + "</ver:CompanyCode><ver:PCode>"
            + ProductCode
            + "</ver:PCode><ver:AccessUID>?</ver:AccessUID><ver:PlaceID>?</ver:PlaceID><ver:TerminalID>?</ver:TerminalID><ver:AssociateID>?</ver:AssociateID><ver:provinceCode>"
            + LicenseToVerify.ProvinceCode
            + "</ver:provinceCode><ver:drivingLicense>"
            + LicenseToVerify.formattedLicense
            + "</ver:drivingLicense><ver:signature>Y</ver:signature><ver:identificationNo></ver:identificationNo><ver:dateOfBirth>"
            + LicenseToVerify.DateOfBirth
            + "</ver:dateOfBirth><ver:licenseClass>"
            + LicenseToVerify.VehicleClass
            + "</ver:licenseClass><ver:reference>?</ver:reference></ver:SingleDL></soapenv:Body></soapenv:Envelope>"
        
        //let urlString = "https://www.dlvcheck.com/vxdcustomerapi/CustomerService.asmx"
        let urlString = "https://vxdtech.com/vxdcustomerapi/CustomerService.asmx"
        
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
            if (data != nil) {
                var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                let xmlParser = NSXMLParser(data: data!)
                xmlParser.delegate = self
                xmlParser.parse()
                xmlParser.shouldResolveExternalEntities = true
                
            }

            // Next step is local validation
            self.LocalValidation(LicenseToVerify)
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
        print("local validation called")
        
        isLocalValid = true
        
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
        
        SocialValidation(LicenseToValidate)
    }
    
    // MARK Social Validation
    func SocialValidation(personToVerify : UserLicense) {
        print("called social validation")
        
        var url : String = "https://service.socure.com/api/2.5/EmailAuthScore?socurekey=7ed058ad-d6bb-4f1a-ba4f-28ffbcf5eafc&email="
            + personToVerify.emailAddress
            + "&firstname="
            + personToVerify.firstName
            + "&surname="
            + personToVerify.lastName
            + "&country=CA"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                self.AddressVerify(personToVerify)
                
                if (data != nil) {
                    let jsonResult: NSObject! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSObject
                    if (jsonResult != nil) {
                        let preScore = jsonResult.valueForKey("data")
                        self.condifenceScore = String(Double((preScore?.valueForKey("confidence"))! as! NSNumber))
                        self.fraudScore = String(Double((preScore?.valueForKey("fraudscore"))! as! NSNumber))
                        self.authScore = String(Double((preScore?.valueForKey("authscore"))! as! NSNumber))
                    } else {
                        // couldn't load JSON, look at error
                        print("no results found")
                    }
                }
                else {
                    print("data is nil")
                }
            }
            catch {
                print(error)
            }
        })
    }
    
    func AddressVerify(personToVerify : UserLicense) {
        print("address verify called")
        var url : String = "http://geocoder.ca/?stno="
            + ""
            + "&adresst="
            + personToVerify.streetName
            + "&city="
            + personToVerify.city
            + "&prov="
            + personToVerify.ProvinceCode
            + "&postal="
            + "&id="
            + "&geoit=XML"
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                print("address verify finished")
                self.GeoLocationVerifiy()
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
    
    func GeoLocationVerifiy() {
        var url : String = "http://geocoder.ca/?latt="
            + latitude
            + "&longt="
            + longitude
            + "&reverse=1"
            + "&geoit=XML"
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                print("address verify finished")
                self.finished()
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
    
    func finished() {
        //self.performSegueWithIdentifier("loading", sender: self)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        //(segue.destinationViewController as! ConfidenceLevelViewController).emailAddress = emailLabel.text!
    }
    
    // MARK : Geolocation delegates 
    
}

extension ConfidenceLevelViewController : CLLocationManagerDelegate {
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
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}
