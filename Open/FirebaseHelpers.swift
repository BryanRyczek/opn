//
//  FirebaseHelpers.swift
//  Open
//
//  Created by Bryan Ryczek on 10/31/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import Foundation
import GooglePlaces
import SwiftyJSON
import FirebaseDatabase

//MARK: Firebase components properties
var placeRef = FIRDatabase.database().reference(withPath: "placeid")


func cacheBusiness(business: Business) {

    let businessRef = placeRef.child(business.placeID.lowercased())
    businessRef.setValue(business.toAnyObject())
    
}


extension String {
    func makeFirebaseString() -> String{
        let arrCharacterToReplace = [".","#","$","[","]"]
        var finalString = self
        
        for character in arrCharacterToReplace{
            finalString = finalString.replacingOccurrences(of: character, with: " ")
        }
        
        return finalString
    }
}

func firebaseTimeStringToDate (_ string: String) -> Date {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    let count = string.characters.count
    
    if count == 5 {
        dateFormatter.dateFormat = "HH:mm"
    } else if count == 8 {
        dateFormatter.dateFormat = "hh:mm a"
    }
    
    guard let date = dateFormatter.date(from: string) else {
        return Date()
    }
    
    let newDate =  currentDateCustomTime(date)
    
    return newDate
}

func addColonToGoogleTimeString (_ string: String) -> String {
    if string.characters.count != 4 { return string }
    
    var newString = string
    let idx = newString.index(newString.startIndex, offsetBy: 2)
    newString.insert(":", at: idx)
    return newString
    
}

func currentDateCustomTime(_ dateWithTime: Date)  -> Date {
    
    let currentDate = Date()
    let calendar = Calendar.current
    
    var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: currentDate)
    let timeComponents = calendar.dateComponents([.hour, .minute], from: dateWithTime)
    dateComponents.hour = timeComponents.hour
    dateComponents.minute = timeComponents.minute
    
    guard let newDate = calendar.date(from: dateComponents) else {
        return Date()
    }
    
    return newDate
}

func openUntil(_ business: Business) -> String {
    
    
    var closeTime: String = ""
    
    if let today = addDay(date: Date()).dayOfWeek() {
        switch today {
        case "monday":
            closeTime = business.mondayClose
        case "tuesday":
            closeTime = business.tuesdayClose
        case"wednesday":
            closeTime = business.wednesdayClose
        case"thursday":
            closeTime = business.thursdayClose
        case"friday":
            closeTime = business.fridayClose
        case"saturday":
            closeTime = business.saturdayClose
        case"sunday":
            closeTime = business.sundayClose
        default:
            break
        }
    }
    
    closeTime = addColonToGoogleTimeString(closeTime)
    
    return closeTime
}

func nextOpen(_ business: Business) -> String {
    
    var openTime: String = ""
    
    if let today = addDay(date: Date()).dayOfWeek() {
        switch today {
        case "monday":
            openTime = business.mondayOpen
        case "tuesday":
            openTime = business.tuesdayOpen
        case"wednesday":
            openTime = business.wednesdayOpen
        case"thursday":
            openTime = business.thursdayOpen
        case"friday":
            openTime = business.fridayOpen
        case"saturday":
            openTime = business.saturdayOpen
        case"sunday":
            openTime = business.sundayOpen
        default:
            break
        }
    }
    
    openTime = addColonToGoogleTimeString(openTime)
    
    return openTime
}



func getOpenClose(_ business: Business) -> [Date] {
    
    let date : [Date] = []
    
    var openTime: String = ""
    var closingTime: String = ""
    
    if let today = Date().dayOfWeek() {
        switch today {
        case "monday":
            openTime = business.mondayOpen
            closingTime = business.mondayClose
        case "tuesday":
            openTime = business.tuesdayOpen
            closingTime = business.tuesdayClose
        case"wednesday":
            openTime = business.wednesdayOpen
            closingTime = business.wednesdayClose
        case"thursday":
            openTime = business.thursdayOpen
            closingTime = business.thursdayClose
        case"friday":
            openTime = business.fridayOpen
            closingTime = business.fridayClose
        case"saturday":
            openTime = business.saturdayOpen
            closingTime = business.saturdayClose
        case"sunday":
            openTime = business.sundayOpen
            closingTime = business.sundayClose
        default:
            break
        }
    }
    
    let todayOpenDate = firebaseTimeStringToDate(openTime)
    var todayCloseDate = firebaseTimeStringToDate(closingTime)
    
    todayCloseDate = openBeforeClose(todayOpenDate, close: todayCloseDate)
    
    return [todayOpenDate, todayCloseDate]
}

func addDay(date: Date) -> Date {
    let calendar = Calendar.current
    let newClose = calendar.date(byAdding: .day, value: 1, to: date)
    return newClose!
}

func openBeforeClose (_ open: Date, close: Date) -> Date {
    if open > close {
        let calendar = Calendar.current
        let newClose = calendar.date(byAdding: .day, value: 1, to: close)
        return newClose!
    } else {
        return close
    }
}

func isDateWithinInverval(_ open: Date, close: Date) -> Bool {
    var isOpen : Bool = false
    let currentDate = Date()
    
    if currentDate > open && close > currentDate {
        isOpen = true
    }
    
    return isOpen
}


extension Date {
    func stringify() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
