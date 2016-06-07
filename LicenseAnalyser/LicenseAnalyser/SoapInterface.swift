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
        soap.username = ""
        soap.password = ""
        
        soap.userAgent = "SOAPEngine"
        soap.actionNamespaceSlash = true
        soap.version = SOAPVersion.VERSION_1_1
        soap.responseHeader = true
        
        soap.setValue("param-value", forKey: "param-name")
        soap.requestURL("https://vxdtech.com/vxdcustomerapi/CustomerService.asmx",
                        soapAction: "http://www.my-web.com/My-Method-name",
                        completeWithDictionary: { (statusCode : Int,
                            dict : [NSObject : AnyObject]!) -> Void in
                            
                            var result:Dictionary = dict as Dictionary
                            NSLog("%@", result)
                            
        }) { (error : NSError!) -> Void in
            
            NSLog("%@", error)
        }
    }
}
