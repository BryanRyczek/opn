//
//  IsOpenViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 11/10/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit

class IsOpenViewController: UIViewController {

    let openCloseTimes : [String: String] =
        [    "mondayOpen" : "13:00",
             "mondayClose" : "23:00",
             "tuesdayOpen" : "08:00 AM",
             "tuesdayClose" : "03:00 PM",
             "wednesdayOpen" : "08:00 AM",
             "wednesdayClose" : "03:00 PM",
             "thursdayOpen" : "08:00 AM",
             "thursdayClose" : "05:23 PM",
             "fridayOpen" : "08:00 AM",
             "fridayClose" : "03:00 PM",
             "saturdayOpen" : "08:00 AM",
             "saturdayClose" : "05:00 PM",
             "sundayOpen" : "08:00",
             "sundayClose" : "17:00" ]
    
    var todayOpen : Date = Date()
    var todayClose : Date = Date()
    
    enum TimeError: Error {
        case couldNotConvert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try setOpenClose()
        } catch {
            print("$#1T")
        }
        print("\(todayOpen)...............\(todayClose)")
        print(isDateWithinInverval(todayOpen, close: todayClose))
        // Do any additional setup after loading the view.
    }
    
    func setOpenClose() throws {
        
        guard let today = Date().dayOfWeek() else {
            throw  TimeError.couldNotConvert }
        let todayPlusOpen: String = today + "Open"
        let todayPlusClose: String = today + "Close"
        todayOpen = try convertFirebaseTimeStringToDate(openCloseTimes[todayPlusOpen]!)
        todayClose = try convertFirebaseTimeStringToDate(openCloseTimes[todayPlusClose]!)
    
    }
    
    func convertFirebaseTimeStringToDate (_ firebaseString: String) throws -> Date {
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .short
        let count = firebaseString.characters.count
        
        if count == 5 {
            dateFormatter.dateFormat = "HH:mm"
        } else if count == 8 {
            dateFormatter.dateFormat = "hh:mm a"
        }
        
        guard let date = dateFormatter.date(from: firebaseString) else {
            throw  TimeError.couldNotConvert }
        
        let newDate = try currentDateCustomTime(date)
        
        return newDate
    }

    func currentDateCustomTime(_ dateWithTime: Date) throws -> Date {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: currentDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: dateWithTime)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        guard let newDate = calendar.date(from: dateComponents) else {
            throw TimeError.couldNotConvert
        }
        
        return newDate
    }
    
    func isDateWithinInverval(_ open: Date, close: Date) -> Bool {
        var isOpen : Bool = false
        let currentDate = Date()
        
        if currentDate > open && close > currentDate {
            isOpen = true
        }
        
        return isOpen
    }
    
}

//extension Date {
//    
//    func dayNumberOfWeek() -> Int? {
//        return Calendar.current.dateComponents([.weekday], from: self).weekday
//    }
//    
//    func dayOfWeek() -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.string(from: self).lowercased()
//        // or use lowercaseed(with: locale)
//    }
//    
//}
