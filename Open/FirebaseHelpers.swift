//
//  FirebaseHelpers.swift
//  Open
//
//  Created by Bryan Ryczek on 10/31/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import Foundation

func firebaseTimeStringToDate (string: String) -> Date {
    
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
    
    let newDate =  currentDateCustomTime(dateWithTime: date)
    
    return newDate
}

func currentDateCustomTime(dateWithTime: Date)  -> Date {
    
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

func getOpenClose(business: Business) -> [Date] {
    
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
    
    let todayOpenDate = firebaseTimeStringToDate(string: openTime)
    let todayCloseDate = firebaseTimeStringToDate(string: closingTime)
    
    return [todayOpenDate, todayCloseDate]
}

func isDateWithinInverval(open: Date, close: Date) -> Bool {
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
