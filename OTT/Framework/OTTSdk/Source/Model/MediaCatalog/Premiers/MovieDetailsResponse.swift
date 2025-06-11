//
//  MovieDetailsResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class MovieDetailsResponse: NSObject {
    public var playButtonInfo = PlayButtonInfo()
    public var movieDetails = MovieDetails()
    public var purchaseInfo = PurchaseInfo()
    public var terms = [Term]()
    public var trailerInfo = TrailerInfo()
    public var geoInfo = GeoInfo()
    public var newGeoInfo = NewGeoInfo()
    public var isZipCodeNeeded = false
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        if let obj = json["playButtonInfo"] as? [String : Any]{
            playButtonInfo = PlayButtonInfo.init(withJSON: obj)
        }
        if let obj = json["movieDetails"] as? [String : Any]{
            movieDetails = MovieDetails.init(withJSON: obj)
        }
        if let obj = json["purchaseInfo"] as? [String : Any]{
            purchaseInfo = PurchaseInfo.init(withJSON: obj)
        }
        terms = Term.terms(withJSON: json["terms"])
        if let obj = json["purchaseInfo"] as? [String : Any]{
            trailerInfo = TrailerInfo.init(withJSON: obj)
        }
        if let obj = json["geoInfo"] as? [String : Any]{
            geoInfo = GeoInfo.init(withJSON: obj)
        }

        newGeoInfo = NewGeoInfo.init(withJSON: json["newGeoInfo"])
        isZipCodeNeeded = Utility.getBoolValue(value: json["isZipCodeNeeded"])
    }
}
