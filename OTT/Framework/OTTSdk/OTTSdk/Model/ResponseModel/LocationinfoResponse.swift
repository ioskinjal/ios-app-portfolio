//
//  LocationinfoResponse.swift
//  OTTSdk
//
//  Created by Muzaffar on 04/08/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class LocationinfoResponse: YuppModel {
    
    internal struct StoredLocationinfo {
        internal static var lastUpdated : Date?
        internal static var response : LocationinfoResponse?
        internal static func getLocationinfoResponse() -> LocationinfoResponse? {
            guard lastUpdated != nil else {
                response = nil
                return nil
            }
//            let elapsed = Date().timeIntervalSince(lastUpdated!)
//            if elapsed <= 3600 // 1 hr
//            {
//                return StoredLocationinfo.response
//            }
//            return nil
            return StoredLocationinfo.response
        }
    }
    
    public var ipInfo = IpInfo()
    public var productInfo = ProductInfo()
    public var clientInfo = ClientInfo()
    public var analyticsInfo = LocationAnalyticsInfo()
    public var rawData = [String : Any]()

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        print(LocationinfoResponse.StoredLocationinfo.getLocationinfoResponse() ?? "nill")
        
        if let _ipInfo = json["ipInfo"] as? [String : Any]{
            ipInfo = IpInfo(_ipInfo)
        }
        if let _productInfo = json["productInfo"] as? [String : Any]{
            productInfo = ProductInfo.init(_productInfo)
        }
        if let _clientInfo = json["clientInfo"] as? [String : Any]{
            clientInfo = ClientInfo.init(_clientInfo)
        }
        if let _analyticsInfo = json["analyticsInfo"] as? [String : Any]{
            analyticsInfo = LocationAnalyticsInfo.init(_analyticsInfo)
        }
        rawData = json
        LocationinfoResponse.StoredLocationinfo.lastUpdated = Date()
        LocationinfoResponse.StoredLocationinfo.response = self
    }
}

public class IpInfo: YuppModel {
    public var city = ""
    public var continentCode = ""
    public var latitude = ""
    public var continentName = ""
    public var timezone = ""
    public var trueIP = ""
    public var country = ""
    public var longitude = ""
    public var postalCode = ""
    public var countryCode = ""
    public var region = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        city = getString(value: json["city"])
        continentCode = getString(value: json["continentCode"])
        latitude = getString(value: json["latitude"])
        continentName = getString(value: json["continentName"])
        timezone = getString(value: json["timezone"])
        trueIP = getString(value: json["trueIP"])
        country = getString(value: json["country"])
        longitude = getString(value: json["longitude"])
        postalCode = getString(value: json["postalCode"])
        countryCode = getString(value: json["countryCode"])
        region = getString(value: json["region"])
    }
}


public class ProductInfo: YuppModel {
    public struct Params {
        var product = ""
    }
    
    public var params = Params()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let product = (json["params"] as? [String : Any])?["Product"] as? String{
            params = Params(product: product)
        }
    }
}

public class ClientInfo: YuppModel {
    public var versionNumber = ""
    public var name = ""
    public var server = ""
    public var clientInfoDescription = ""
    public var params  = [String : Any]()
    public var updateType = 0
    
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        versionNumber = getString(value: json["versionNumber"])
        name = getString(value: json["name"])
        server = getString(value: json["server"])
        clientInfoDescription = getString(value: json["description"])
        if let _params = (json["params"] as? [String : Any]){
            params = _params
        }
        updateType = getInt(value: json["updateType"])
    }
}
/*
 "authKey": "f825addb-20a7-3d46-8052-0600b0ee6edf",
 "analyticsId": "10001",
 "serverTime": 1501855023284,
 "hbRateInMillis": 60000,
 "collectorAPI": "ace.api.yuppcdn.net"
 */
public class LocationAnalyticsInfo: YuppModel {
    public var authKey = ""
    public var analyticsId = ""
    public var serverTime : NSNumber = 0
    public var hbRateInMillis : NSNumber = 0
    public var collectorAPI = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        authKey = getString(value: json["authKey"])
        analyticsId = getString(value: json["analyticsId"])
        serverTime = getNSNumber(value: json["serverTime"])
        hbRateInMillis = getNSNumber(value: json["hbRateInMillis"])
        collectorAPI = getString(value: json["collectorAPI"])
    }
}


