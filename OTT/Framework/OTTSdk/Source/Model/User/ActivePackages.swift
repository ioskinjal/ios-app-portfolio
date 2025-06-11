//
//  ActivePackages.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 17/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ActivePackages: NSObject {
   
    public var name = ""
    public var showCancelButton = false
    public var purchaseDate = ""
    public var nextRenewDate = ""
    public var amount : Float = 0
    public var packageType = ""
    public var status = ""
    public var currency = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        name = Utility.getStringValue(value: json["name"])
        showCancelButton = Utility.getBoolValue(value: json["showCancelButton"])
        purchaseDate = Utility.getStringValue(value: json["purchaseDate"])
        nextRenewDate = Utility.getStringValue(value: json["nextRenewDate"])
        amount = Utility.getFloatValue(value: json["amount"])
        packageType = Utility.getStringValue(value: json["packageType"])
        status = Utility.getStringValue(value: json["status"])
        currency = Utility.getStringValue(value: json["currency"])
    }
    
    public static func packagesList(json : Any?) -> [ActivePackages]{
        var list = [ActivePackages]()
        if let objJson = json as? [[String : Any]]{
            for obj in objJson {
                list.append(ActivePackages.init(withJSON: obj))
            }
        }
        return list
    }
}
