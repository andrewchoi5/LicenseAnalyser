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

class ConfidenceLevelViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate, PPScanDelegate, CLLocationManagerDelegate {


    var isFinished = false

    var firstVisit = true
    
    var latitude = String()
    var longitude = String()
    
    var emailAddress = String()
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    var isLocalValid = false
    var isVerXValid = false
    
    var isPostalCodeValid = false
    var isGeoLocationValid = false
    var isPhotoSelected = false
    
    var localValidationScore = 0.0
    
    var postalScore: Double = 0.0
    var creditScore: Double = 0.0
    
    var condifenceScore: Double = Double()
    var fraudScore: Double = Double()
    var authScore: Double = Double()
    
    var coreScore: Double = 0.0
    var enhancedScore: Double = 0.0
    var govtScore: Double = 0.0
    var socialScore: Double = 0.0
    
    let coreTotal: Double = 50.0
    let enhacedTotal: Double = 100.0
    let govtTotal: Double = 100.0
    let socialTotal: Double = 25.0
    
    var currentCount = 70
    var maxCount = 100
    
    let provinces = ["AB", "BC", "MB", "NB", "NL", "NT", "NS", "NU", "ON", "PE", "QC", "SK", "YT"]
    var geoLocationResult: String = String()
    var geoScore: Double = Double()
    
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    
    
    let locationManager = CLLocationManager()
    
    func locationManagerInit() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func newAngle() -> Double {
        return Double(360 * (currentCount / maxCount))
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        if (isPhotoSelected == false) {
            launchCamera()
        }
        
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
    
    override func viewDidLoad() {
        launchCamera()
        super.viewDidLoad()
        circularProgressView.startAngle = -90
        circularProgressView.clockwise = true
        circularProgressView.gradientRotateSpeed = 2
        circularProgressView.roundedCorners = false
        
    }
    
    func finishedLoadingValue() {
        //self.performSegueWithIdentifier("loading", sender: self)
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
        
        scanningViewController?.dismissViewControllerAnimated(false, completion: {

            self.circularProgressView.animateFromAngle(0, toAngle: 1920, duration: 10) { completed in
                if completed {
                    print("animation stopped, completed")
                    //if (self.isFinished == true) {
                     //   self.performSegueWithIdentifier("loading", sender: self)
                   // }
                } else {
                    print("animation stopped, was interrupted")
                }

            }
        })

        
 
        
        let scanConroller : PPScanningViewController = scanningViewController as! PPScanningViewController
        print("camera dismissed")
       
        
        
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
                
                var firstName = usdlResult.getField(kPPCustomerFirstName)
                var lastName = usdlResult.getField(kPPCustomerFamilyName)
                var fullName = usdlResult.getField(kPPCustomerFullName)
                
                var gender = usdlResult.getField(kPPSex)
                
                var issueDate = usdlResult.getField(kPPDocumentIssueDate)
                var expireDate = usdlResult.getField(kPPDocumentExpirationDate)
                
                var fullAddress = usdlResult.getField(kPPFullAddress)
                
                var licenseNo = usdlResult.getField(kPPCustomerIdNumber)
                licenseNo = licenseNo.stringByReplacingOccurrencesOfString("-", withString: "")
                
                let province = usdlResult.getField(kPPAddressJurisdictionCode)
                
                let vehicleClass = usdlResult.getField(kPPJurisdictionVehicleClass)
                
                let streetName = usdlResult.getField(kPPAddressStreet)
                let city = usdlResult.getField(kPPAddressCity)
                // Making DOB format YYYYMMDD
                var DateOfBirth = usdlResult.getField(kPPDateOfBirth)
                
                var index = DateOfBirth.startIndex.advancedBy(4)
                let year = DateOfBirth.substringFromIndex(index)
                
                index = DateOfBirth.startIndex.advancedBy(2)
                let month = DateOfBirth.substringToIndex(index)
                
                var startIndex = DateOfBirth.startIndex.advancedBy(2)
                index = DateOfBirth.startIndex.advancedBy(4)
                let day = DateOfBirth.substringWithRange(Range<String.Index>(start: startIndex, end: index))
                DateOfBirth = DateOfBirth.stringByReplacingOccurrencesOfString(year, withString: "")
                DateOfBirth = year + DateOfBirth
                
                
                let person = UserLicense(firstName: firstName, lastName: lastName, fullName: fullAddress,gender: gender, LicenseIdNumber: usdlResult.getField(kPPCustomerIdNumber), formattedLicense: licenseNo, DateOfBirth: DateOfBirth, dateMonth: month, dateDay: day, ProvinceCode: province, VehicleClass: vehicleClass, expiryDate: expireDate, dateIssued: issueDate, fullAddress: fullAddress, emailAddress: emailAddress, streetName: streetName, city: city)
    
            
                
                User.firstName = firstName
                User.lastName = lastName
                User.LicenseIdNumber = usdlResult.getField(kPPCustomerIdNumber)
                User.ProvinceCode = province
                User.fullAddress = fullName
                User.emailAddress = emailAddress
                User.city = city
                User.PostalCode = usdlResult.getField(kPPAddressPostalCode)
                
                let test = usdlResult.getAllStringElements()
                UserFields = usdlResult.getAllStringElements()
                
                UserFields.removeValueForKey("uncertain")
                UserFields.removeValueForKey("pdf417")
                UserFields.removeValueForKey("Inventory control number")
                
                let genderFormat = UserFields["Sex"]
                UserFields.removeValueForKey("Sex")
                
                
                if (genderFormat as! String == "1") {
                    UserFields["Sex"] = "M"
                }
                else if (genderFormat as! String == "2") {
                    UserFields["Sex"] = "F"
                }
                
                
                validate(person)
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
        
        if (currentElementName == "prov" && firstVisit == true) {
            geoLocationResult = string
            firstVisit = false
        }
        
        if (currentElementName == "postal" && string != "\n") {
            let postalCode = string
            let userPostalCode = User.PostalCode.stringByReplacingOccurrencesOfString(" ", withString: "")
            
            let postalCodeFirstThree = postalCode.substringWithRange(Range<String.Index>(start: postalCode.startIndex, end: postalCode.startIndex.advancedBy(2)))
            
            let userPostalCodeFirstThree =  userPostalCode.substringWithRange(Range<String.Index>(start: userPostalCode.startIndex, end: userPostalCode.startIndex.advancedBy(2)))
            
            if (postalCodeFirstThree == userPostalCodeFirstThree) {
                isPostalCodeValid = true
            }
        }
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
        
        let loginString = NSString(format: "%@:%@", prodUser, prodPassword)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        
        theRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session = NSURLSession.sharedSession()
        /*
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
        
        dataTask.resume()*/
        
        self.GeoLocationVerify(LicenseToVerify)
    }
    
    // MARK - Validation
    func GeoLocationVerify(personToVerify : UserLicense) {
        var url : String = "http://geocoder.ca/?latt="
            + LocationData.latitude
            + "&longt="
            + LocationData.longitude
            + "&reverse=1"
            + "&geoit=XML"
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                self.AddressVerify(personToVerify)
                if (data != nil) {
                    var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    
                    let xmlParser = NSXMLParser(data: data!)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
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
    
    func AddressVerify(personToVerify : UserLicense) {
        print("address verify called")
        
        let streetAddress = personToVerify.streetName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let city = personToVerify.city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        
        var url : String = "http://geocoder.ca/?adresst="
            + streetAddress
            + "&stno="
            + "&city="
            + city
            + "&prov="
            + personToVerify.ProvinceCode
            + "&postal=&id=&geoit=XML"
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                print("address verify finished")
                self.LocalValidation(personToVerify)
                if (data != nil) {
                    var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    
                    let xmlParser = NSXMLParser(data: data!)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
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
    
    func LocalValidation(LicenseToValidate: UserLicense) {
        print("local validation called")
        
        isLocalValid = true
        
        // License should be 15 characters long
        if (LicenseToValidate.formattedLicense.characters.count != 15) {
            // INVALID
            isLocalValid = false
        } else {
            localValidationScore += 7
        }
        
        // First letter of license is the first letter of last name
        let index = LicenseToValidate.LicenseIdNumber.startIndex
        let firstLicense = LicenseToValidate.LicenseIdNumber[index]
        let firstOfLastName = LicenseToValidate.lastName[index]
        
        if (firstLicense != firstOfLastName) {
            // INVALID
            isLocalValid = false
        } else {
            localValidationScore += 7
        }
        
        // Characters 12-15 of License are Birth MMDD
        let lastFourLicense = LicenseToValidate.formattedLicense.substringWithRange(Range<String.Index>(start: LicenseToValidate.formattedLicense.startIndex.advancedBy(11), end: LicenseToValidate.formattedLicense.endIndex))
        
        let lastFourDOB = LicenseToValidate.DateOfBirth.substringWithRange(Range<String.Index>(start: LicenseToValidate.DateOfBirth.startIndex.advancedBy(4), end: LicenseToValidate.DateOfBirth.endIndex))
        
        // If male
        if (Int(LicenseToValidate.gender) == 1) {
            if (lastFourLicense != lastFourDOB) {
                isLocalValid = false
            } else {
                localValidationScore += 7
            }
        }
        
        if (Int(LicenseToValidate.gender) == 2) {
            var validDOB = String(Int(LicenseToValidate.dateMonth)! + 50) + LicenseToValidate.dateDay
            print("DOB")
            print(validDOB)
            if (lastFourLicense != validDOB) {
                isLocalValid = false
            } else {
                localValidationScore += 7
            }
        }
        
        // Last 2 Years is YY
        let lastTwoYearDOB = LicenseToValidate.DateOfBirth.substringWithRange(Range<String.Index>(start: LicenseToValidate.DateOfBirth.startIndex.advancedBy(2), end: LicenseToValidate.DateOfBirth.startIndex.advancedBy(4)))
        
        let lastTwoYearLicense = LicenseToValidate.formattedLicense.substringWithRange(Range<String.Index>(start: LicenseToValidate.formattedLicense.startIndex.advancedBy(9), end: LicenseToValidate.formattedLicense.startIndex.advancedBy(11)))
        
        if (lastTwoYearDOB != lastTwoYearLicense) {
            isLocalValid = false
        } else {
            localValidationScore += 7
        }
        
        let currentDate = NSDate()
        
        let dateString = LicenseToValidate.expiryDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        let expDate = dateFormatter.dateFromString(dateString)
        
        if (currentDate.compare(expDate!) == NSComparisonResult.OrderedDescending) {
            isLocalValid = false
        } else {
            localValidationScore += 7
        }
        
        SocialValidation(LicenseToValidate)
    }
    
    // Social Validation
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

                
                if (data != nil) {
                    let jsonResult: NSObject! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSObject
                    if (jsonResult != nil) {
                        let preScore = jsonResult.valueForKey("data")
                        
                        let error = jsonResult.valueForKey("status") as! String
                        if (error != "Error") {
                            self.condifenceScore = Double((preScore?.valueForKey("confidence"))! as! NSNumber)
                            self.fraudScore = Double((preScore?.valueForKey("fraudscore"))! as! NSNumber)
                            self.authScore = Double((preScore?.valueForKey("authscore"))! as! NSNumber)
                            print("auth score = " + String(self.condifenceScore))
                        }
                        
                    } else {
                        // couldn't load JSON, look at error
                        print("no results found")
                    }
                }
                else {
                    print("data is nil")
                }
                // API CALLS ARE DONE
                self.finished()
            }
            catch {
                print(error)
            }
        })
        
    }

    
    func finished() {
        calculateScores()
        isFinished = true
        self.performSegueWithIdentifier("loading", sender: self)
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
    
    func calculateScores() {
        // Core Score out of 50
        
        if (geoLocationResult == "ON") {
            geoScore = 15
        } else if (provinces.contains(geoLocationResult)) {
            geoScore = 5
        } else {
            geoScore = 0
        }
        
        coreScore = localValidationScore + geoScore
        
        // Enhanced Score out of 100
        if (isPostalCodeValid) {
            postalScore = enhacedTotal
        }
        
        enhancedScore = postalScore + creditScore
        
        // Govt Score out of 100
        if (isVerXValid) {
            govtScore = govtTotal
        }
        
        // Social Score out of 25
        condifenceScore = (condifenceScore * 25.0/3.0)
        fraudScore = (fraudScore * 25.0/3.0)
        authScore = (authScore * 25.0/3.0) / 10
        
        socialScore = condifenceScore + fraudScore + authScore
        
        GlobalScore.coreScore = self.coreScore
        GlobalScore.govtScore = self.govtScore
        GlobalScore.enhancedScore = self.enhancedScore
        GlobalScore.socialScore = self.socialScore
        
        //self.performSegueWithIdentifier("loading", sender: self)
        
    }
    // MARK : Geolocation delegates
}


