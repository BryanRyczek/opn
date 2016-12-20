//
//  FoundationHelpers.swift
//  Open
//
//  Created by Bryan Ryczek on 12/20/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: Offset to CLLocation - Compensates for curvature of the earth!
func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    let distRadians = distanceMeters / (6372797.6) // earth radius in meters
    
    let lat1 = origin.latitude * M_PI / 180
    let lon1 = origin.longitude * M_PI / 180
    
    let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
    let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
    
    return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
}

func getDayOfWeek() -> DayOfWeek {
    let date = Date()
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    return (DayOfWeek(rawValue: weekday))!
}
