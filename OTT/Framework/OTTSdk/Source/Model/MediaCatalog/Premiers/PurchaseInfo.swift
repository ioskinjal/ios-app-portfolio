//
//  PurchaseInfo.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PurchaseInfo: NSObject {
    public var purchaseStatus = 0
    public var purchaseShortText = ""
    public var purchaseText = ""
    public var expiryText = ""
    public var expiryTime = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        purchaseStatus = Utility.getIntValue(value: json["purchaseStatus"])
        purchaseShortText = Utility.getStringValue(value: json["purchaseShortText"])
        purchaseText = Utility.getStringValue(value: json["purchaseText"])
        expiryText = Utility.getStringValue(value: json["expiryText"])
        expiryTime = Utility.getStringValue(value: json["expiryTime"])
    }
}
