//
//  Package.swift
//  OTTSdk
//
//  Created by Muzaffar on 17/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Package: YuppModel {
    public var name = ""
    public var purchaseDate : NSNumber = 0
    public var expiryDate : NSNumber = 0
    public var packageType = ""
    public var id = 0
    public var gateway = ""
    public var isRecurring = false
    public var isUnSubscribed = false
    public var isCurrentlyActivePlan = 0
    public var changePlanAvailable = 0
    public var code = ""
    public var gatewayName = ""
    public var message = ""
    public var packageAmount : Float = 0
    public var saleAmount : Float = 0
    public var points = 0
    public var effectiveFrom = ""
    public var currencySymbol = ""
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        name = getString(value:json["name"])
        purchaseDate = getNSNumber(value:json["purchaseDate"])
        expiryDate = getNSNumber(value:json["expiryDate"])
        packageType = getString(value: json["packageType"])
        effectiveFrom = getString(value: json["effectiveFrom"])
        gateway = getString(value: json["gateway"])
        isRecurring = getBool(value: json["isRecurring"])
        isUnSubscribed = getBool(value: json["isUnSubscribed"])
        id = getInt(value: json["id"])
        isCurrentlyActivePlan = getInt(value: json["isCurrentlyActivePlan"])
        
        changePlanAvailable = getInt(value: json["changePlanAvailable"])
        points = getInt(value: json["points"])
        code = getString(value: json["code"])
        gatewayName = getString(value: json["gatewayName"])
        message = getString(value: json["message"])
        if json.keys.contains("currencySymbol") {
            currencySymbol = getString(value: json["currencySymbol"])
        }
        packageAmount = getFloat(value: json["packageAmount"])
        saleAmount = getFloat(value: json["saleAmount"])
    }
    
    public static func array(json : Any?) -> [Package]{
        var list = [Package]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Package(obj))
            }
        }
        return list
    }
}
