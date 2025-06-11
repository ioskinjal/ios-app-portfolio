//
//  AdDetails.swift
//  YuppTV
//
//  Created by Muzaffar on 15/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class AdDetails: NSObject {
    public var showAds = false
    public var ads = [Any]()
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        showAds = Utility.getBoolValue(value: json["showAds"])
        if let _ads = json["ads"] as? [Any]{
            ads = _ads
        }
    }
}
