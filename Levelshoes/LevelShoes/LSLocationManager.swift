//
//  LSLocationManager.swift
//  LevelShoes
//
//  Created by kanhiya kumar jha on 15/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreLocation

class LSLocationManager: NSObject,CLLocationManagerDelegate {
    static let shared = LSLocationManager()
    var city : String = ""
    var state : String = ""
    var country : String = ""
    var locationManager:CLLocationManager!
    func configLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        if CLLocationManager.locationServicesEnabled() {
                   locationManager.requestLocation();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = (placemarks ?? [CLPlacemark]()) as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                LSLocationManager.shared.country  = "\(placemark.country!) "
                 LSLocationManager.shared.city  = "\(placemark.locality!) "
                LSLocationManager.shared.state  = "\(placemark.administrativeArea!)"
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

//                self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        print("user latitude = \(newLocation.coordinate.latitude)")
               print("user longitude = \(newLocation.coordinate.longitude)")
        
    }

}
