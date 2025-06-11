//
//  NewGeoInfo.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 05/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class NewGeoInfo: NSObject {
    public var iconUrl = ""
    public var geoInfoDescription = ""
    public var regions = [String]()
    
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : Any?){
        super.init()
        guard let _json = json as? [String : Any] else{
            return
        }
        iconUrl = Utility.getStringValue(value: _json["iconUrl"])
        geoInfoDescription = Utility.getStringValue(value: _json["description"])
        if let _regions = _json["regions"] as? [String]{
            regions = _regions
        }
    }
}
