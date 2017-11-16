//
// Location Manager
// ___PROJECTNAME___


import Foundation

class LocationManager: CLLocationManager {
    
    override init() {
        super.init()
        requestWhenInUseAuthorization()
        delegate = self
        desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func stop() {
        stopUpdatingLocation()
    }
    
    func start() {
        startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else {
            return
        }
        //LocationUtilities.shared.deviceLocation = coordinate //save device's loacation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        debugPrint(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(status) {
        case .notDetermined, .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation()
        }
    }
}
