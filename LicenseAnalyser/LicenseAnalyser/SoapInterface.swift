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
        let soap = SOAPEngine()
        
        soap.authorizationMethod = SOAPAuthorization.AUTH_BASIC
        soap.username = "1648346"
        soap.password = "oFkWR977V"
        
        soap.userAgent = "SOAPEngine"
        soap.actionNamespaceSlash = true
        soap.version = SOAPVersion.VERSION_1_1
        soap.responseHeader = true
        
        soap.setValue("loginId", forKey: "1648346")
        soap.setValue("password", forKey: "oFkWR977V")
        soap.setValue("tokenKey", forKey: "P6Fy2gsO23KuUdvckwLqqA==")
        soap.setValue("version", forKey: "1.0")
        soap.setValue("CompanyCode", forKey: "53")
        soap.setValue("PCode", forKey: "pkera56g5")
        soap.setValue("AccessUID", forKey: "")
        soap.setValue("PlaceID", forKey: "")
        soap.setValue("TerminalID", forKey: "")
        soap.setValue("AssociateID", forKey: "")
        soap.setValue("provinceCode", forKey: "ON")
        soap.setValue("drivingLicense", forKey: "P66681858950819")
        soap.setValue("signature", forKey: "Y")
        soap.setValue("identificationNo", forKey: "")
        soap.setValue("dateOfBirth", forKey: "19950819")
        soap.setValue("licenseClass", forKey: "")
        soap.setValue("reference", forKey: "")
        
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
