//
// Map Utilities
// ___PROJECTNAME___

import Foundation
import MapKit

class MapUtilities {
    
    static let shared = MapUtilities()
    private var deviceLocation: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D() // return devices location/ if you have location utilities type LocationUtilities.shared.myLocation
    }
    
    public enum DirectionMode {
        case walking
        case driving
    }
    
    private init() {}
    
    func openGoogle(lat: String, lng: String) {
        let location = "\(lat),\(lng)"
        guard let deviceLocation = deviceLocation, let doubleLat = Double(lat), let doubleLng = Double(lng) else {
            openGoogleMapsNavigation(location, mode: .driving)
            return
        }
        if !LocationUtilities.shared.isNear(lat1: deviceLocation.latitude, lon1: deviceLocation.longitude, lat2: doubleLat, lon2: doubleLng) {
            openGoogleMapsNavigation(location, mode: .driving)
        }else {
            openGoogleMapsNavigation(location, mode: .walking)
        }
    }
    
    func openApple(lat: String, lng: String) {
        guard let location = deviceLocation, let doubleLat = Double(lat), let doubleLng = Double(lng) else {
            openAppleMapsNavigation(lat: lat, lng: lng, mode: .driving)
            return
        }
        if !LocationUtilities.shared.isNear(lat1: location.latitude, lon1: location.longitude, lat2: doubleLat, lon2: doubleLng) {
            openAppleMapsNavigation(lat: lat, lng: lng, mode: .driving)
        }else {
            openAppleMapsNavigation(lat: lat, lng: lng, mode: .walking)
        }
    }
    
    func openGoogleMapsNavigation(_ location: String, mode: DirectionMode){
        guard UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!), let url = URL(string: "comgooglemaps://?saddr=&daddr=\(location)&directionsmode=" + (mode == .driving ? "driving" : "walkning"))  else {
            return
        }
        UIApplication.shared.openURL(url)
    }
    
    func openAppleMapsNavigation(lat: String, lng: String, mode: DirectionMode) {
        guard let doubleLat = Double(lat), let doubleLng = Double(lng) else {
            return
        }
        let coordinate = CLLocationCoordinate2DMake(doubleLat, doubleLng)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : mode == .driving ? MKLaunchOptionsDirectionsModeDriving : MKLaunchOptionsDirectionsModeWalking])
    }
    
    func openGoogleMapsNavigation(from locationA: String, to locationB: String, mode: DirectionMode) {
        guard UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!), let url = URL(string: "comgooglemaps://?saddr=\(locationA)&daddr=\(locationB)&directionsmode=" + (mode == .driving ? "driving" : "walkning"))  else {
            return
        }
        UIApplication.shared.openURL(url)
    }
    
    func openAppleMapsNavigation(fromLat: String, fromLng: String, toLat: String, toLng: String, name: String, mode: DirectionMode) {
        guard let doubleLat = Double(fromLat), let doubleLng = Double(fromLng), let doubleLat2 = Double(toLat), let doubleLng2 = Double(toLng) else {
            return
        }
        let coordinate = CLLocationCoordinate2DMake(doubleLat, doubleLng)
        let coordinate2 = CLLocationCoordinate2DMake(doubleLat2, doubleLng2)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        let mapItem2 = MKMapItem(placemark: MKPlacemark(coordinate: coordinate2, addressDictionary: nil))
        mapItem2.name = name
        MKMapItem.openMaps(with: [mapItem, mapItem2], launchOptions: [MKLaunchOptionsDirectionsModeKey : mode == .driving ? MKLaunchOptionsDirectionsModeDriving : MKLaunchOptionsDirectionsModeWalking])
    }
}

