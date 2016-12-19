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

func getDayOfWeek() -> DayOfWeek {
    let date = Date()
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    return (DayOfWeek(rawValue: weekday))!
}

//MARK: JSON From googlePlace
func jsonForGooglePlaceID (place: GMSPlace, completionHandler: @escaping (JSON, Error?) -> Void ) -> URLSessionDataTask {
    
    //MARK: URL Request properties
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    if dataTask != nil {
        dataTask?.cancel()
    }
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    let url = urlFromGooglePlace(place: place)
    
    dataTask = defaultSession.dataTask(with: url as URL) {
        (data, response, error) in
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // check for any errors
        guard error == nil else {
            completionHandler(JSON.null, error)
            print("error calling GET on /todos/1")
            return
        }
        // make sure we got data
        guard let responseData = data else {
            completionHandler(JSON.null, error)
            print("Error: did not receive data")
            return
        }
     
        do {
            guard let jsonObj = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                print("error trying to convert data to JSON")
                return
            }
         
            let json = JSON(data: data!)
            
            completionHandler(json, nil)
            return
            
        } catch {
            print("error trying to convert data to JSON")
            return
        }
        
    }
    
    dataTask?.resume()
    return dataTask!
}


let acceptedBusinessTypes : [String] = ["accounting",
                                        "airport",
                                        "amusement_park",
                                        "aquarium",
                                        "art_gallery",
                                        "atm",
                                        "bakery",
                                        "bank",
                                        "bar",
                                        "beauty_salon",
                                        "bicycle_store",
                                        "book_store",
                                        "bowling_alley",
                                        "bus_station",
                                        "cafe",
                                        "campground",
                                        "car_dealer",
                                        "car_rental",
                                        "car_repair",
                                        "car_wash",
                                        "casino",
                                        "cemetery",
                                        "church",
                                        "city_hall",
                                        "clothing_store",
                                        "convenience_store",
                                        "courthouse",
                                        "dentist",
                                        "department_store",
                                        "doctor",
                                        "electrician",
                                        "electronics_store",
                                        "embassy",
                                        "finance",
                                        "fire_station",
                                        "florist",
                                        "food",
                                        "funeral_home",
                                        "furniture_store",
                                        "gas_station",
                                        "general_contractor",
                                        "grocery_or_supermarket",
                                        "gym",
                                        "hair_care",
                                        "hardware_store",
                                        "hindu_temple",
                                        "home_goods_store",
                                        "hospital",
                                        "insurance_agency",
                                        "jewelry_store",
                                        "laundry",
                                        "lawyer",
                                        "library",
                                        "liquor_store",
                                        "local_government_office",
                                        "locksmith",
                                        "lodging",
                                        "meal_delivery",
                                        "meal_takeaway",
                                        "mosque",
                                        "movie_rental",
                                        "movie_theater",
                                        "moving_company",
                                        "museum",
                                        "night_club",
                                        "painter",
                                        "park",
                                        "parking",
                                        "pet_store",
                                        "pharmacy",
                                        "physiotherapist",
                                        "plumber",
                                        "police",
                                        "post_office",
                                        "real_estate_agency",
                                        "restaurant",
                                        "roofing_contractor",
                                        "rv_park",
                                        "school",
                                        "shoe_store",
                                        "shopping_mall",
                                        "spa",
                                        "stadium",
                                        "storage",
                                        "store",
                                        "subway_station",
                                        "synagogue",
                                        "taxi_stand",
                                        "train_station",
                                        "transit_station",
                                        "travel_agency",
                                        "university",
                                        "veterinary_care",
                                        "zoo"]

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
