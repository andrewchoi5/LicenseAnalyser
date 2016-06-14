//
//  ScoreDataModel.swift
//  LicenseAnalyser
//
//  Created by Dylan Trachsel on 2016-06-13.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import Foundation

struct GlobalScore {
    static var socialScore = 0.0
    static var govtScore = 0.0
    static var enhancedScore = 0.0
    static var coreScore = 0.0
}

struct LocationData {
    static var longitude = ""
    static var latitude = ""
}

struct User {
    static var firstName = ""
    static var lastName = ""
    static var LicenseIdNumber = ""
    static var ProvinceCode = ""
    static var fullAddress = ""
    static var emailAddress = ""
    static var city = ""
    static var PostalCode = ""
}

var UserFields : [NSObject : AnyObject] = [:]
