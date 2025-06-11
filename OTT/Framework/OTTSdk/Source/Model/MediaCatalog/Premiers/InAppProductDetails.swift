//
//  InAppProductDetails.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class InAppProductDetails: NSObject {
    public var appleTVImageUrl = ""
    public var iPhoneImageUrl = ""
    public var freeTrialDuration = 0
    public var productId = ""
    public var packageId = 0
    public var iPadImageUrl = ""
    /// 7 : iPhone/iPad/iPod & 55 : AppleTV
    public var allowedDevices = [Int]()
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        appleTVImageUrl = Utility.getStringValue(value: json["appleTVImageUrl"])
        iPhoneImageUrl = Utility.getStringValue(value: json["iPhoneImageUrl"])
        freeTrialDuration = Utility.getIntValue(value: json["freeTrialDuration"])
        productId = Utility.getStringValue(value: json["productId"])
        packageId = Utility.getIntValue(value: json["packageId"])
        iPadImageUrl = Utility.getStringValue(value: json["iPadImageUrl"])
        if let desc = json["allowedDevices"] as? [Int]{
            allowedDevices = desc
        }
    }
}
