//
//  UserLicense.swift
//  LicenseAnalyser
//
//  Created by Dylan Trachsel on 2016-06-08.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import Foundation

public class UserLicense {
    var firstName : String
    var lastName : String
    var fullName : String
    var LicenseIdNumber : String
    var formattedLicense : String
    var DateOfBirth : String
    var ProvinceCode : String
    var VehicleClass : String
    var expiryDate : String
    var dateIssued : String
    var fullAddress : String
    
    init(firstName: String, lastName : String, fullName : String, LicenseIdNumber: String, formattedLicense : String, DateOfBirth: String, ProvinceCode: String, VehicleClass: String, expiryDate : String, dateIssued : String, fullAddress : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.LicenseIdNumber = LicenseIdNumber
        self.formattedLicense = formattedLicense
        self.DateOfBirth = DateOfBirth
        self.ProvinceCode = ProvinceCode
        self.VehicleClass = VehicleClass
        self.expiryDate = expiryDate
        self.dateIssued = dateIssued
        self.fullAddress = fullAddress
    }
}


