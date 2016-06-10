//
//  SoapInterface.swift
//  LicenseAnalyser
//
//  Created by Dylan Trachsel on 2016-06-07.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import Foundation
import UIKit

public class SOAPInterface : NSObject, NSXMLParserDelegate {
    var mutableData:NSMutableData = NSMutableData()
    var currentElementName:NSString = ""
    
    static func VerifyCard(LicenseToVerify: UserLicense) {
    }
    
    static func VerifyCard() {
        /*let person = UserLicense(LicenseIdNumber: "N02035370820919", DateOfBirth: "19820919", ProvinceCode: "ON", VehicleClass: "")
        let user = "1648346"
        let pass = "oFkWR977V"
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ver='VerXdirect.API'><soapenv:Header/><soapenv:Body><ver:SingleDL><ver:loginId>"
            + user
            + "</ver:loginId><ver:password>"
            + pass
            + "</ver:password><ver:tokenKey>P6Fy2gsO23KuUdvckwLqqA==</ver:tokenKey><ver:version>1.0</ver:version><ver:CompanyCode>53</ver:CompanyCode><ver:PCode>pkera56g5</ver:PCode><ver:AccessUID>?</ver:AccessUID><ver:PlaceID>?</ver:PlaceID><ver:TerminalID>?</ver:TerminalID><ver:AssociateID>?</ver:AssociateID><ver:provinceCode>"
            + person.ProvinceCode
            + "</ver:provinceCode><ver:drivingLicense>"
            + person.LicenseIdNumber
            + "</ver:drivingLicense><ver:signature>Y</ver:signature><ver:identificationNo></ver:identificationNo><ver:dateOfBirth>"
            + person.DateOfBirth
            + "</ver:dateOfBirth><ver:licenseClass>?</ver:licenseClass><ver:reference>?</ver:reference></ver:SingleDL></soapenv:Body></soapenv:Envelope>"
        /*
         let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:ver='VerXdirect.API'><soap:Header/><soap:Body><ver:SingleDL><ver:loginId>mehranna@ca.ibm.com</ver:loginId><ver:password>oFkWR977V11</ver:password><ver:tokenKey>P6Fy2gsO23KuUdvckwLqqA==</ver:tokenKey><ver:version>1.0</ver:version><ver:CompanyCode>53</ver:CompanyCode><ver:PCode>pkera56g5</ver:PCode><ver:AccessUID>?</ver:AccessUID><ver:PlaceID>?</ver:PlaceID><ver:TerminalID>?</ver:TerminalID><ver:AssociateID>?</ver:AssociateID><ver:provinceCode>ON</ver:provinceCode><ver:drivingLicense>N02035370820919</ver:drivingLicense><ver:signature>Y</ver:signature><ver:identificationNo></ver:identificationNo><ver:dateOfBirth>19820919</ver:dateOfBirth><ver:licenseClass>?</ver:licenseClass><ver:reference>?</ver:reference></ver:SingleDL></soap:Body></soap:Envelope>"*/
        
        let urlString = "https://vxdtech.com/vxdcustomerapi/CustomerService.asmx"
        
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
            
            let xmlParser = NSXMLParser(data: data!)
            xmlParser.delegate = self as? NSXMLParserDelegate
            xmlParser.parse()
            xmlParser.shouldResolveExternalEntities = true
            
            
        })
        
        dataTask.resume()
*/
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElementName == "ResultArgumentName" {
            //txtFahrenheit.text = string
        }
    }
}