//
//  Extension+GLGeocoder.swift
//  Luxongo
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 admin. All rights reserved.
//


import MapKit
extension CLGeocoder{
    static func getCoordinate(_ addressString : String,
                              completionHandler: @escaping(CLLocationCoordinate2D) -> Void ) {
        //completionHandler: @escaping(CLLocationCoordinate2D, Error?) -> Void )
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else{
                        // handle no location found
                        print(error?.localizedDescription ?? "ERROR in get lat long")
                        completionHandler(kCLLocationCoordinate2DInvalid)
                        return
                }
                completionHandler(location.coordinate)
                return
            }
            else{
                print(error?.localizedDescription ?? "ERROR in get lat long")
                completionHandler(kCLLocationCoordinate2DInvalid)
            }
        }
    }
    
    static func openMapFromAddress(_ addressString : String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else{
                        // handle no location found
                        print(error?.localizedDescription ?? "ERROR in get lat long")
                        return
                }
                let latitude: CLLocationDegrees = location.coordinate.latitude
                let longitude: CLLocationDegrees = location.coordinate.longitude
                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = addressString //customerSide_ProviderDetails?.address
                mapItem.openInMaps(launchOptions: options)
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "http://maps.apple.com/?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)")!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(NSURL.init(string: "http://maps.apple.com/?ll=\(String(describing: location.coordinate.latitude)),\(String(describing: location.coordinate.longitude))")! as URL)
                }
            }
            else{
                print(error?.localizedDescription ?? "ERROR in get lat long")
            }
        }
    }
    
}
//Use:
//CLGeocoder.openMapFromAddress(serviceList[indexPath.row].address)n
