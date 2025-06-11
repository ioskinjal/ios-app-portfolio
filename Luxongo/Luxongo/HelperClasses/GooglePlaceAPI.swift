//
//  GooglePlaceAPI.swift
//  Luxongo
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

import UIKit
import GooglePlaces

class GooglePlaceAPI: NSObject{
    //Signtin object
    static let shared = GooglePlaceAPI()
    
    //MARK: - Internal Properties
    var googlePlaceBlock: ((_ lat: CLLocationDegrees, _ long: CLLocationDegrees, _ addr: String, _ placeObj: GMSPlace) -> Void)?
    
    //Properties
    fileprivate var currentVC: UIViewController?
    
    func showGooglePlaceView(vc: UIViewController) {
        currentVC = vc
        //https://developers.google.com/places/ios-api/
        //TODO: Display google place picker
        let acController = GMSAutocompleteViewController()
        /*
         let filter = GMSAutocompleteFilter()
         filter.country = "HR"
         acController.autocompleteFilter = filter
         */
        acController.delegate = self
        currentVC?.present(acController, animated: true, completion: nil)
    }
    
}

//MARK:- Google Place API
//https://stackoverflow.com/questions/28793940/how-to-add-google-places-autocomplete-to-xcode-with-swift-tutorial
extension GooglePlaceAPI: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        print("Place address: \(place.formattedAddress!)")
        print("Place coordinate latitude: \(place.coordinate.latitude)")
        print("Place coordinate longitude: \(place.coordinate.longitude)")
        //latitude = String(place.coordinate.latitude)
        //longitude = String(place.coordinate.longitude)
        
        //        latitude = place.coordinate.latitude
        //        longitude = place.coordinate.longitude
        //
        //        address = place.formattedAddress
        
        self.googlePlaceBlock?(place.coordinate.latitude, place.coordinate.longitude, place.formattedAddress ?? "", place)
        
        currentVC?.dismiss(animated: true, completion: {
            self.currentVC = nil
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        currentVC?.dismiss(animated: true, completion: {
            self.currentVC = nil
        })
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        currentVC?.dismiss(animated: true, completion: {
            self.currentVC = nil
        })
    }
    
}
