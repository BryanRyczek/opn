//
//  GooglePlacesHelpers.swift
//  Open
//
//  Created by Bryan Ryczek on 12/20/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import Foundation
import GooglePlaces
import SwiftyJSON
import Firebase

//MARK: API URL from GMSPlace
func urlFromGooglePlace(place: GMSPlace) -> NSURL {
    
    let appKey = "AIzaSyDZTCAf9pXnDcMGHu1Qan8cSk68sTVQPm4" //MARK: This is the webservice Google Key, NOT the iOS app key!
    let urlString : String = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + place.placeID + "&key=" + appKey
    let url = NSURL(string: urlString)
    
    return url!
    
}

//MARK: Static Maps! url from googlePlace
func staticMapURL(place: GMSPlace) -> URL {
    
    var bizInitial = place.name[0]
    let lat = place.coordinate.latitude
    let long = place.coordinate.longitude
    let latString : String = "\(lat)"
    let longString : String = "\(long)"
    
    let staticMapPrefix : String = "https://maps.googleapis.com/maps/api/staticmap?"
    let center : String = "center=\(latString),\(longString)"
    let zoom : String = "zoom=18"
    let size : String = "size=300x200"
    let type : String = "maptype=roadmap"
    let marker1 : String = "markers=color:blue%7Clabel:\(bizInitial)%7C\(latString),\(longString)"
    let key : String = "key=AIzaSyCiUyiGQcPxaMDnFJNhSijrr1dZq2XQeuA"
    let style : String = "style="
    
    let staticMapURLString : String = staticMapPrefix + center + "&" + zoom + "&" + size + "&" + type + "&" + marker1 + "&" + key
    let url : URL = URL(string: staticMapURLString)!
    
    return url
    
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
            let bizName : String = json["result"].stringValue
            print("JSON for business \(bizName): \(jsonObj)")
            
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

//MARK: Business From googlePlace
func BusinessForGooglePlaceID (place: GMSPlace, completionHandler: @escaping (Business?, Error?) -> Void ) -> URLSessionDataTask {
    
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
            completionHandler(nil, error)
            print("error calling get for datatask")
            return
        }
        // make sure we got data
        guard let responseData = data else {
            completionHandler(nil, error)
            print("Error: did not receive data")
            return
        }
        
        do {
            guard let jsonObj = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                print("error trying to convert data to JSON")
                return
            }
            
            let json = JSON(data: data!)
            
            let business : Business = businessFromPlaceAndJSON(place: place, json: json)
            
            completionHandler(business, nil)
            return
            
        } catch {
            print("error trying to convert data to JSON")
            return
        }
        
    }
    
    dataTask?.resume()
    return dataTask!
}

//MARK: Business from GMSPlace and JSON
func businessFromPlaceAndJSON(place: GMSPlace, json: JSON) -> Business {
    
    var placeID : String = ""
    var key: String
    var ref: FIRDatabaseReference?
    //Name
    var businessName : String = ""
    var contactName : String = ""
    //Security
    var password : String = ""
    //Tags
    var businessTypeOne : String = ""
    var businessTypeTwo : String = ""
    var businessTypeThree : String = ""
    //Hours
    var mondayOpen : String = ""
    var mondayClose : String = ""
    var tuesdayOpen : String = ""
    var tuesdayClose : String = ""
    var wednesdayOpen : String = ""
    var wednesdayClose : String = ""
    var thursdayOpen : String = ""
    var thursdayClose : String = ""
    var fridayOpen : String = ""
    var fridayClose : String = ""
    var saturdayOpen : String = ""
    var saturdayClose : String = ""
    var sundayOpen : String = ""
    var sundayClose : String = ""
    //Address
    var addressLineOne : String = ""
    var addressLineTwo : String = ""
    var city : String = ""
    var state : String = ""
    var zip : String = ""
    //Hood
    var neighborhood : String = ""
    //Contact Info
    var phoneNumber : String = ""
    var website : String = ""
    var email : String = ""
    //etc.
    var businessDescription : String = ""
    //lat - long
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var streetNumber : String?
    var route : String?
    
    placeID = place.placeID
    
    latitude = place.coordinate.latitude as! Double
    longitude = place.coordinate.longitude as! Double
    
    var addressArray = place.formattedAddress?.components(separatedBy: ",")
    
    for component in place.addressComponents! {
        switch component.type {
        case "street_number":
            streetNumber = component.name
        case "route":
            route = component.name
        case "locality":
            city = component.name
        case "administrative_area_level_1":
            state = component.name
        case "postal_code":
            zip = component.name
        case "neighborhood":
            neighborhood = component.name.makeFirebaseString()
        default:
            break
        }
        
        if let num = streetNumber, let rt = route {
            addressLineOne = num + " " + rt
        } else {
            addressLineOne = (addressArray?[0])!
        }
        
    }
    
    // Test to see if there is a second address line in the address array
    if let array = addressArray {
        if array.count >= 3 {
            if city == array[2].trimmingCharacters(in: .whitespaces) {
                addressLineTwo = (addressArray?[1])!
            }
        }
    }
    
    businessName = place.name
    if let num = place.phoneNumber {
        phoneNumber = num
    }
    
    if let site = place.website {
        website = site.absoluteString
    }
    
    var descriptionArray = [String]()
    
    for (i, type) in place.types.enumerated() {
        
        if acceptedBusinessTypes.contains(type) {
            descriptionArray.append(type)
        }
        
    }
    
    for (i, type) in descriptionArray.enumerated() {
        switch i {
        case 0:
            businessTypeOne = type
        case 1:
            businessTypeTwo = type
        case 2:
            businessTypeThree = type
        default:
            break
        }
    }
    
    let arrayValue = json["result"]["opening_hours"]["periods"]
    
    for (i, value) in arrayValue.enumerated() {
        
        let dayOfWeek = value.1["open"]["day"]
        
        switch dayOfWeek {
        case 0:
            
            if let suo = value.1["open"]["time"].string {
                sundayOpen = addColonToGoogleTimeString(suo)
            }
            if let suc = value.1["close"]["time"].string {
                sundayClose = addColonToGoogleTimeString(suc)
            }
        case 1:
            if let mo = value.1["open"]["time"].string {
                mondayOpen = addColonToGoogleTimeString(mo)
            }
            if let mc = value.1["close"]["time"].string {
                mondayClose = addColonToGoogleTimeString(mc)
            }
            
        case 2:
            if let tuo = value.1["open"]["time"].string {
                tuesdayOpen = addColonToGoogleTimeString(tuo)
            }
            if let tuc = value.1["close"]["time"].string {
                tuesdayClose = addColonToGoogleTimeString(tuc)
            }
        case 3:
            if let wo = value.1["open"]["time"].string {
                wednesdayOpen = addColonToGoogleTimeString(wo)
            }
            if let wc = value.1["close"]["time"].string {
                wednesdayClose = addColonToGoogleTimeString(wc)
            }
            
        case 4:
            if let tho = value.1["open"]["time"].string {
                thursdayOpen = addColonToGoogleTimeString(tho)
            }
            if let thc = value.1["close"]["time"].string {
                thursdayClose = addColonToGoogleTimeString(thc)
            }
        case 5:
            if let fo = value.1["open"]["time"].string {
                fridayOpen = addColonToGoogleTimeString(fo)
            }
            if let fc = value.1["close"]["time"].string {
                fridayClose = addColonToGoogleTimeString(fc)
            }
        case 6:
            if let sao = value.1["open"]["time"].string {
                saturdayOpen = addColonToGoogleTimeString(sao)
            }
            if let sac = value.1["close"]["time"].string {
                saturdayClose = addColonToGoogleTimeString(sac)
            }
        default:
            break
        }
    }
    
    
    
    let business = Business(placeID: placeID,
                            businessName: businessName,
                            contactName: contactName,
                            password: password,
                            businessTypeOne: businessTypeOne,
                            businessTypeTwo: businessTypeTwo,
                            businessTypeThree: businessTypeThree,
                            mondayOpen: mondayOpen,
                            mondayClose: mondayClose,
                            tuesdayOpen: tuesdayOpen,
                            tuesdayClose: tuesdayClose,
                            wednesdayOpen: wednesdayOpen,
                            wednesdayClose: wednesdayClose,
                            thursdayOpen: thursdayOpen,
                            thursdayClose: thursdayClose,
                            fridayOpen: fridayOpen,
                            fridayClose: fridayClose,
                            saturdayOpen: saturdayOpen,
                            saturdayClose: saturdayClose,
                            sundayOpen: sundayOpen,
                            sundayClose: sundayClose,
                            addressLineOne: addressLineOne,
                            addressLineTwo: addressLineTwo,
                            city: city,
                            state: state,
                            zip: zip,
                            neighborhood: neighborhood,
                            phoneNumber: phoneNumber,
                            website: website,
                            email: email,
                            businessDescription: businessDescription,
                            latitude: latitude,
                            longitude: longitude
    )
    
    
    return business
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

