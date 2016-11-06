//
//  Business.swift
//  Open
//
//  Created by Bryan Ryczek on 10/21/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import FirebaseDatabase

//property ideas
// business owner
// phone number
// hours
enum DayOfWeek : Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
}

struct Address {
    
    var streetNumber : Int?
    var street : String?
    var addressLineTwo: String?
    var city : String
    var state : String
    var zip : Int
    
}

struct Business {
    
    let key: String
    let ref: FIRDatabaseReference?
    //Name
    let businessName : String
    let contactName : String
    //Tags
    let businessTypeOne : String
    let businessTypeTwo : String
    let businessTypeThree : String
    //Hours
    let mondayOpen : String
    let mondayClose : String
    let tuesdayOpen : String
    let tuesdayClose : String
    let wednesdayOpen : String
    let wednesdayClose : String
    let thursdayOpen : String
    let thursdayClose : String
    let fridayOpen : String
    let fridayClose : String
    let saturdayOpen : String
    let saturdayClose : String
    let sundayOpen : String
    let sundayClose : String
    //Address
    let addressLineOne : String
    let addressLineTwo : String
    let city : String
    let state : String
    let zip : String
    //Contact Info
    let phoneNumber : String
    let website : String
    let email : String
    //etc.
    let userDescription : String
    
//    let streetNumber: Int
//    let street : String
//    //let addressLineTwo : String?
//    let city : String
//    let state : String
//    let zip : String
//    let latitude : Double
//    let longitude : Double
//    var completed: Bool
//    let addedByUser: String
    
    var isOpen: Bool {
        get {
            return self.isOpen
        }
        set {
            let day = getDayOfWeek()
            dump(day)
        }
    }
    
    var location : CLLocation {
        get {
            return self.location
        }
        set {
            let newLocation : CLLocation = CLLocation(latitude: 42.382884, longitude: -71.071386)
            location = newLocation
        }
    }
    
    init(//Key
          key: String = "",
         //Name
          businessName : String,
          contactName : String,
        //Tags
          businessTypeOne : String,
          businessTypeTwo : String,
          businessTypeThree : String,
        //Hours
          mondayOpen : String,
          mondayClose : String,
          tuesdayOpen : String,
          tuesdayClose : String,
          wednesdayOpen : String,
          wednesdayClose : String,
          thursdayOpen : String,
          thursdayClose : String,
          fridayOpen : String,
          fridayClose : String,
          saturdayOpen : String,
          saturdayClose : String,
          sundayOpen : String,
          sundayClose : String,
        //Address
          addressLineOne : String,
          addressLineTwo : String,
          city : String,
          state : String,
          zip : String,
        //Contact Info
          phoneNumber : String,
          website : String,
          email : String,
        //etc.
          userDescription : String ) {
        
        self.key = key
        self.businessName = businessName
        self.contactName = contactName
        self.businessTypeOne = businessTypeOne
        self.businessTypeTwo = businessTypeTwo
        self.businessTypeThree = businessTypeThree
        self.mondayOpen = mondayOpen
        self.mondayClose = mondayClose
        self.tuesdayOpen = tuesdayOpen
        self.tuesdayClose = tuesdayClose
        self.wednesdayOpen = wednesdayOpen
        self.wednesdayClose = wednesdayClose
        self.thursdayOpen = thursdayOpen
        self.thursdayClose = thursdayClose
        self.fridayOpen = fridayOpen
        self.fridayClose = fridayClose
        self.saturdayOpen = saturdayOpen
        self.saturdayClose = saturdayClose
        self.sundayOpen = sundayOpen
        self.sundayClose = sundayClose
        self.addressLineOne = addressLineOne
        self.addressLineTwo = addressLineTwo
        self.city = city
        self.state = state
        self.zip = zip
        self.phoneNumber = phoneNumber
        self.website = website
        self.email = email
        self.userDescription = userDescription
        self.ref = nil
        
    }
    
    
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        businessName = snapshotValue["businessName"] as! String
        contactName = snapshotValue["contactName"] as! String
        businessTypeOne = snapshotValue["businessTypeOne"] as! String
        businessTypeTwo = snapshotValue["businessTypeTwo"] as! String
        businessTypeThree = snapshotValue["businessTypeThree"] as! String
        mondayOpen = snapshotValue["mondayOpen"] as! String
        mondayClose = snapshotValue["mondayClose"] as! String
        tuesdayOpen = snapshotValue["tuesdayOpen"] as! String
        tuesdayClose = snapshotValue["tuesdayClose"] as! String
        wednesdayOpen = snapshotValue["wednesdayOpen"] as! String
        wednesdayClose = snapshotValue["wednesdayClose"] as! String
        thursdayOpen = snapshotValue["thursdayOpen"] as! String
        thursdayClose = snapshotValue["thursdayClose"] as! String
        fridayOpen = snapshotValue["fridayOpen"] as! String
        fridayClose = snapshotValue["fridayClose"] as! String
        saturdayOpen = snapshotValue["saturdayOpen"] as! String
        saturdayClose = snapshotValue["saturdayClose"] as! String
        sundayOpen = snapshotValue["sundayOpen"] as! String
        sundayClose = snapshotValue["sundayClose"] as! String
        addressLineOne = snapshotValue["addressLineOne"] as! String
        addressLineTwo = snapshotValue["addressLineTwo"] as! String
        city = snapshotValue["city"] as! String
        state = snapshotValue["state"] as! String
        zip = snapshotValue["zip"] as! String
        phoneNumber = snapshotValue["phoneNumber"] as! String
        website = snapshotValue["website"] as! String
        email = snapshotValue["email"] as! String
        userDescription = snapshotValue["userDescription"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
                  //"isOpen" : isOpen,
             "businessName": businessName,
             "contactName" : contactName,
         "businessTypeOne" : businessTypeOne,
         "businessTypeTwo" : businessTypeTwo,
       "businessTypeThree" : businessTypeThree,
              "mondayOpen" : mondayOpen,
             "mondayClose" : mondayClose,
             "tuesdayOpen" : tuesdayOpen,
            "tuesdayClose" : tuesdayClose,
           "wednesdayOpen" : wednesdayOpen,
          "wednesdayClose" : wednesdayClose,
            "thursdayOpen" : thursdayOpen,
           "thursdayClose" : thursdayClose,
              "fridayOpen" : fridayOpen,
             "fridayClose" : fridayClose,
            "saturdayOpen" : saturdayOpen,
           "saturdayClose" : saturdayClose,
              "sundayOpen" : sundayOpen,
             "sundayClose" : sundayClose,
          "addressLineOne" : addressLineOne,
          "addressLineTwo" : addressLineTwo,
                    "city" : city,
                   "state" : state,
                     "zip" : zip,
             "phoneNumber" : phoneNumber,
                 "website" : website,
                   "email" : email,
         "userDescription" : userDescription,
            ]
    }
    
}

func getDayOfWeek() -> DayOfWeek {
    let date = Date()
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    return (DayOfWeek(rawValue: weekday))!
}
