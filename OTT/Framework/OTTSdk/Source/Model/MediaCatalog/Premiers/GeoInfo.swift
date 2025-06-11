//
//  GeoInfo.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit
///info of Movie Availability in user current country ,states and Cities.
public class GeoInfo: NSObject {
    public var name = ""
    public var icon = ""
    public var geoInfoDescription = ""
    public var localities = [Localities]()
    
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        name = Utility.getStringValue(value: json["name"])
        icon = Utility.getStringValue(value: json["icon"])
        geoInfoDescription = Utility.getStringValue(value: json["description"])
        localities = Localities.localities(withJSON: json["localities"])
    }
}
