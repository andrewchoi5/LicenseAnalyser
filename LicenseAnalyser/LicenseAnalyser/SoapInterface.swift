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

public class SOAPInterface {
    static func VerifyCard() {
        var soap = SOAPEngine()
        
        soap.authorizationMethod = SOAPAuthorization.AUTH_BASIC
        soap.username = "1648346"
        soap.password = "oFkWR977V"
        
        soap.userAgent = "SOAPEngine"
        soap.actionNamespaceSlash = true
        soap.version = SOAPVersion.VERSION_1_1
        soap.responseHeader = true
        
        soap.setValue("loginId", forKey: "1648346")
        soap.setValue("password", forKey: "oFkWR977V")
        soap.setValue("tokenKey", forKey: "param-name")
        soap.setValue("version", forKey: "param-name")
        soap.setValue("CompanyCode", forKey: "param-name")
        soap.setValue("PCode", forKey: "param-name")
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
}
