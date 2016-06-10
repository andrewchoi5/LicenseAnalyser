//
//  SoapInterface.swift
//  LicenseAnalyser
//
//  Created by Dylan Trachsel on 2016-06-07.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import Foundation
import UIKit
import SOAPEngine64

public class SOAPInterface : NSObject, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate {
    var mutableData:NSMutableData = NSMutableData()
    var currentElementName:NSString = ""
    
    static func VerifyCard(LicenseToVerify: UserLicense) {
        let soap = SOAPEngine()
        
        soap.authorizationMethod = SOAPAuthorization.AUTH_BASIC
        soap.username = "1648346"
        soap.password = "oFkWR977V"
        
        soap.userAgent = "SOAPEngine"
        soap.actionNamespaceSlash = true
        soap.version = SOAPVersion.VERSION_1_1
        soap.responseHeader = true
        
        soap.setValue("1648346", forKey: "loginId")
        soap.setValue("oFkWR977V", forKey: "password")
        soap.setValue("P6Fy2gsO23KuUdvckwLqqA==", forKey: "tokenKey")
        soap.setValue("1.0", forKey: "version")
        soap.setValue("53", forKey: "CompanyCode")
        soap.setValue("pkera56g5", forKey: "PCode")
        soap.setValue("", forKey: "AccessUID")
        soap.setValue("", forKey: "PlaceID")
        soap.setValue("", forKey: "TerminalID")
        soap.setValue("", forKey: "AssociateID")
        soap.setValue(LicenseToVerify.PostalCode, forKey: "provinceCode")
        soap.setValue(LicenseToVerify.LicenseIdNumber, forKey: "drivingLicense")
        soap.setValue("Y", forKey: "signature")
        soap.setValue("", forKey: "identificationNo")
        soap.setValue(LicenseToVerify.DateOfBirth, forKey: "dateOfBirth")
        soap.setValue("", forKey: "licenseClass")
        soap.setValue("", forKey: "reference")
        soap.setValue("loginId", forKey: "1648346")
        soap.setValue("password", forKey: "oFkWR977V")
        soap.setValue("tokenKey", forKey: "P6Fy2gsO23KuUdvckwLqqA==")
        soap.setValue("version", forKey: "1.0")
        soap.setValue("CompanyCode", forKey: "53")
        soap.setValue("PCode", forKey: "pkera56g5")
        soap.setValue("AccessUID", forKey: "param-name")
        soap.setValue("PlaceID", forKey: "param-name")
        soap.setValue("TerminalID", forKey: "param-name")
        soap.setValue("AssociateID", forKey: "param-name")
        soap.setValue("provinceCode", forKey: "param-name")
        soap.setValue("drivingLicense", forKey: "param-name")
        soap.setValue("signature", forKey: "param-name")
        soap.setValue("identificationNo", forKey: "param-name")
        soap.setValue("dateOfBirth", forKey: "param-name")
        soap.setValue("licenseClass", forKey: "param-name")
        soap.setValue("reference", forKey: "param-name")
        
        soap.requestURL("https://vxdtech.com/vxdcustomerapi/CustomerService.asmx",
                        soapAction: "VerXdirect.API/SingleDL",
                        completeWithDictionary: { (statusCode : Int,
                            dict : [NSObject : AnyObject]!) -> Void in
                            
                            var result:Dictionary = dict as Dictionary
                            NSLog("%@", result)
                            
        }) { (error : NSError!) -> Void in
            
            NSLog("%@", error)
        }

    }
    
    static func VerifyCard() {
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ver='VerXdirect.API'><soapenv:Header/><soapenv:Body><ver:SingleDL><ver:loginId>1648346</ver:loginId><ver:password>oFkWR977V</ver:password><ver:tokenKey>P6Fy2gsO23KuUdvckwLqqA==</ver:tokenKey><ver:version>1.0</ver:version><ver:CompanyCode>53</ver:CompanyCode><ver:PCode>pkera56g5</ver:PCode><ver:AccessUID>?</ver:AccessUID><ver:PlaceID>?</ver:PlaceID><ver:TerminalID>?</ver:TerminalID><ver:AssociateID>?</ver:AssociateID><ver:provinceCode>ON</ver:provinceCode><ver:drivingLicense>N02035370820919</ver:drivingLicense><ver:signature>Y</ver:signature><ver:identificationNo></ver:identificationNo><ver:dateOfBirth>19820919</ver:dateOfBirth><ver:licenseClass>?</ver:licenseClass><ver:reference>?</ver:reference></ver:SingleDL></soapenv:Body></soapenv:Envelope>"
         
         let urlString = "https://vxdtech.com/vxdcustomerapi/CustomerService.asmx"
        
        /*
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><CelsiusToFahrenheit xmlns='http://www.w3schools.com/xml/'><Celsius>44</Celsius></CelsiusToFahrenheit></soap12:Body></soap12:Envelope>"
        
        
        let urlString = "http://www.w3schools.com/xml/tempconvert.asmx"*/
        
        let url = NSURL(string: urlString)
        
        let theRequest = NSMutableURLRequest(URL: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.setValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        
         let username = "1648346"
         let password = "oFkWR977V"
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
            
        })
        
        dataTask.resume()

    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        let response = NSString(data: mutableData, encoding: NSUTF8StringEncoding)
        
        let xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElementName == "CelsiusToFahrenheitResult" {
            //txtFahrenheit.text = string
        }
    }
}
*/