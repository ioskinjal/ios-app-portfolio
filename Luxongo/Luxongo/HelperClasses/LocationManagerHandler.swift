//
//  LocationManager.swift
//
//  Created by NCrypted Technologies.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManagerHandler : NSObject  {
    static var shared = LocationManagerHandler()

    fileprivate var locationManager = CLLocationManager()
    var currentLatitude : CLLocationDegrees = 0.0
    var currentLongitude : CLLocationDegrees = 0.0
    
    //var lastTimeStamp: Date?
    var currentLocationBlock : ((_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        //This will updating location in background mode also
        locationManager.allowsBackgroundLocationUpdates = false//true
        //If above property is true and In capabilities BackGround Modes-> location update ->must be checked other wise app crash!
        
        
        //This will indicating that app is using location in background mode
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
        
        //This will not stop updating location automatically, thought this is not recommanded, app will use more energy
        locationManager.pausesLocationUpdatesAutomatically = false
        
    }
    
    func initialize() {
        //initialize first time data
    }
    
    //Check location permission if not show alert
    func checkLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            self.checkLocationPermissionStatus(status: CLLocationManager.authorizationStatus())
        } else {
            self.showPermissionAlert()
        }
    }
    
    //Check location permission status
    func checkLocationPermissionStatus(status : CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                showPermissionAlert()
        @unknown default:
            showPermissionAlert()
        }
    }
    
    //Check location permission given or not
    func isLocationPermissionGiven() -> Bool {
        if CLLocationManager.locationServicesEnabled() == false {
            return false
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    //Show permission alert and redirect to setting menu
    func showPermissionAlert() {
        let alert = UIAlertController(title: "Access permission!".localized, message: "This app requires access your location.".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            //UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

extension LocationManagerHandler : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       //print("Update current location")
        if let currentLocation = locations.last {
            self.currentLatitude = currentLocation.coordinate.latitude
            self.currentLongitude = currentLocation.coordinate.longitude
            //print("\(self.currentLatitude)")
            //print("\(self.currentLongitude)")
            self.currentLocationBlock?(self.currentLatitude, self.currentLongitude)
            
        }
    }
    
    func startUpdatingLocation() {
        if isLocationPermissionGiven(){
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation() {
        if isLocationPermissionGiven(){
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location: error - \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationPermissionStatus(status: status)
    }
}
