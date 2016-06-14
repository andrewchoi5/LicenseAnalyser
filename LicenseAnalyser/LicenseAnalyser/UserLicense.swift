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
    var gender : String
    var LicenseIdNumber : String
    var formattedLicense : String
    var DateOfBirth : String
    var dateMonth : String
    var dateDay : String
    var ProvinceCode : String
    var VehicleClass : String
    var expiryDate : String
    var dateIssued : String
    var fullAddress : String
    var emailAddress : String
    var streetName : String
    var city : String
    
    init(firstName: String, lastName : String, fullName : String, gender : String, LicenseIdNumber: String, formattedLicense : String, DateOfBirth: String, dateMonth: String, dateDay: String, ProvinceCode: String, VehicleClass: String, expiryDate : String, dateIssued : String, fullAddress : String, emailAddress : String, streetName : String, city : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.gender = gender
        self.LicenseIdNumber = LicenseIdNumber
        self.formattedLicense = formattedLicense
        self.DateOfBirth = DateOfBirth
        self.dateMonth = dateMonth
        self.dateDay = dateDay
        self.ProvinceCode = ProvinceCode
        self.VehicleClass = VehicleClass
        self.expiryDate = expiryDate
        self.dateIssued = dateIssued
        self.fullAddress = fullAddress
        self.emailAddress = emailAddress
        self.streetName = streetName
        self.city = city
    }
}


