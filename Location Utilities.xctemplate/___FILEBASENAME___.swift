//
// Location Utilities
// LocationUtilities
//
//  Created by Vassilis Alexandrof on 15/11/2017.
//  Copyright © 2017 Threenitas. All rights reserved.
//

import Foundation
import Darwin

class LocationUtilities {
    
    static let shared = LocationUtilities()
    
    let aDistanceThatCanBeSaidThatIsNear: Double = 1.5
    let defaultLocation = CLLocationCoordinate2DMake(37.956915, 23.728115)//enter default location
    public var myLocation : CLLocationCoordinate2D? {
        guard deviceLocation == nil else {
            return deviceLocation
        }
        return defaultLocation
    }
    public var deviceLocation: CLLocationCoordinate2D?
    public enum Bearing: Double {
        case north = 0
        case east = 90
        case south = 180
        case west = 270
    }
    
    private init() {}
    
    func distance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let theta = lon1 - lon2
        var dist = sin(lat1.degreesToRadians) * sin(lat2.degreesToRadians) + cos(lat1.degreesToRadians) * cos(lat2.degreesToRadians) * cos(theta.degreesToRadians)
        dist = acos(dist)
        dist = dist.radiansToDegrees
        dist = dist * 60 * 1.1515
        dist = dist * 1.609344
        return Double(round(10 * dist) / 10)
    }
    
    func isNear(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Bool {
        return distance(lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2) < aDistanceThatCanBeSaidThatIsNear
    }
    
    func isNear(locationA: CLLocationCoordinate2D, locationB: CLLocationCoordinate2D) -> Bool {
        return distance(lat1: locationA.latitude, lon1: locationA.longitude, lat2: locationB.latitude, lon2: locationB.longitude) < aDistanceThatCanBeSaidThatIsNear
    }
    
    func locationWithBearing(bearing: Bearing, distanceMeters: Double, origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6)
        let rbearing = bearing.rawValue * .pi/180.0
        let lat1 = origin.latitude * .pi/180
        let lon1 = origin.longitude * .pi/180
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
        let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }
}
