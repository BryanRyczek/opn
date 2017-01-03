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
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    
}

struct Business {
    
    var opnPlaceID : String //Generated upon signup
    let placeID : String //Google places ID for cross reference
    let key: String
    let ref: FIRDatabaseReference?
    //Name
    let businessName : String
    let contactName : String
    //Security
    let password : String
    //Tags
    let businessTypeOne : String
    let businessTypeTwo : String
    let businessTypeThree : String
    let businessTags : [String]
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
    //Hood
    let neighborhood : String
    //Contact Info
    let phoneNumber : String
    let website : String
    let email : String
    //etc.
    let businessDescription : String
    //lat - long
    let latitude : Double
    let longitude : Double

    var isOpen: Bool {
        get {
            let dates = getOpenClose(self)
            return isDateWithinInverval(dates[0], close: dates[1])
        }
    }
    
    var nxtOpn : String {
        get {
            return nextOpen(self)
        }
    }
    
    var opnTil : String {
        get {
            return openUntil(self)
        }
    }
    
    var location : CLLocation {
        get {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    init(//Key
        
          opnPlaceID : String,
          placeID : String,
          key: String = "",
         //Name
          businessName : String,
          contactName : String,
          //Security
          password : String,
        //Tags
          businessTypeOne : String,
          businessTypeTwo : String,
          businessTypeThree : String,
          businessTags : [String],
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
        //Hood
          neighborhood : String,
        //Contact Info
          phoneNumber : String,
          website : String,
          email : String,
        //etc.
          businessDescription : String,
        // lat - long
        latitude : Double,
        longitude : Double
        
        ) {
        
        self.opnPlaceID = opnPlaceID
        self.placeID = placeID
        self.key = key
        self.businessName = businessName
        self.contactName = contactName
        self.password = password
        self.businessTypeOne = businessTypeOne
        self.businessTypeTwo = businessTypeTwo
        self.businessTypeThree = businessTypeThree
        self.businessTags = businessTags
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
        self.neighborhood = neighborhood
        self.phoneNumber = phoneNumber
        self.website = website
        self.email = email
        self.businessDescription = businessDescription
        //lat - long
        self.latitude = latitude
        self.longitude = longitude

        self.ref = nil
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        opnPlaceID = snapshotValue["opnPlaceID"] as! String
        placeID = snapshotValue["placeID"] as! String
        businessName = snapshotValue["businessName"] as! String
        contactName = snapshotValue["contactName"] as! String
        password = snapshotValue["password"] as! String
        businessTypeOne = snapshotValue["businessTypeOne"] as! String
        businessTypeTwo = snapshotValue["businessTypeTwo"] as! String
        businessTypeThree = snapshotValue["businessTypeThree"] as! String
        businessTags = snapshotValue["businessTags"] as! [String]
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
        neighborhood = snapshotValue["neighborhood"] as! String
        phoneNumber = snapshotValue["phoneNumber"] as! String
        website = snapshotValue["website"] as! String
        email = snapshotValue["email"] as! String
        businessDescription = snapshotValue["businessDescription"] as! String
        latitude = snapshotValue["latitude"] as! Double
        longitude = snapshotValue["longitude"] as! Double
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
                  //"isOpen" : isOpen,
              "opnPlaceID" : opnPlaceID,
                 "placeID" : placeID,
             "businessName": businessName,
             "contactName" : contactName,
                "password" : password,
         "businessTypeOne" : businessTypeOne,
         "businessTypeTwo" : businessTypeTwo,
       "businessTypeThree" : businessTypeThree,
            "businessTags" : businessTags,
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
            "neighborhood" : neighborhood,
             "phoneNumber" : phoneNumber,
                 "website" : website,
                   "email" : email,
     "businessDescription" : businessDescription,
                "latitude" : latitude,
               "longitude" : longitude,
            ]
    }
    
}



extension Business {
    mutating func generateOpnPlaceID() {
        self.opnPlaceID = randomOpnKey(length: 27)
    }
}
