//
//  StreamResponse.swift
//  OTTSdk
//
//  Created by Muzaffar on 07/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class StreamResponse: YuppModel {
    public var count = 0
    public var sessionInfo = SessionInfo()
    public var maxBitrateAllowed = 0
    public var streams = [Stream]()
    public var streamStatus = StreamStatus()
    public var analyticsInfo = AnalyticsInfo()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        count = getInt(value: json["count"])
        if let _sessionInfo = json["sessionInfo"] as? [String : Any]{
            sessionInfo = SessionInfo.init(_sessionInfo)
        }
        maxBitrateAllowed = getInt(value: json["maxBitrateAllowed"])
        streams = Stream.streams(json: json["streams"])
        if let _streamStatus = json["streamStatus"] as? [String : Any]{
            streamStatus = StreamStatus.init(_streamStatus)
        }
        if let analytics = json["analyticsInfo"] as? [String : Any]{
            analyticsInfo = AnalyticsInfo.init(analytics)
        }
    }
}

public class Stream: YuppModel {
    public struct Keys {
        public var certificate = ""
        public var licenseKey = ""
    }
    public struct Params {
        public var duration = ""
    }
    public var isDefault = false
    public var keys = Keys()
    public var params = Params()
    public var streamType = ""
    public var url = ""
    public var closeCaptions = CloseCaptions()

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        isDefault = getBool(value: json["isDefault"])
        streamType = getString(value: json["streamType"])
        url = getString(value: json["url"])
        if let closeCaption = json["closeCaptions"] as? [String : Any]{
            closeCaptions = CloseCaptions.init(closeCaption)
        }
        if let dic = json["params"] as? [String : Any]{
            if let duration = dic["duration"] as? String{
                params = Params.init(duration: duration)
            }
        }
        if let dic = json["keys"] as? [String : Any]{
            if getString(value: dic["licenseKey"]).lowercased().contains("invalid content key") || getString(value: dic["licenseKey"]).lowercased().contains("error"){
                keys = Keys(certificate: getString(value: dic["certificate"]), licenseKey: "")
            } else {
                keys = Keys(certificate: getString(value: dic["certificate"]), licenseKey: getString(value: dic["licenseKey"]))
            }
        }
    }
    
    public static func streams(json : Any?) -> [Stream]{
        var list = [Stream]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Stream(obj))
            }
        }
        return list
    }
}


public class AnalyticsInfo: YuppModel, NSCoding {
    public var contentType = ""
    public var dataKey = ""
    public var dataType = ""
    public var id:Int32 = 0
    public var customData = ""
    public var packageType = ""
    
    
    internal override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let obj = aDecoder.decodeObject(forKey: "contentType") as? String {
            self.contentType = obj
        }
        if let obj = aDecoder.decodeObject(forKey: "dataKey") as? String {
            self.dataKey = obj
        }
        
        if let obj = aDecoder.decodeObject(forKey: "dataType") as? String {
            self.dataType = obj
        }
        if let obj = aDecoder.decodeObject(forKey: "customData") as? String {
            self.customData = obj
        }
        if let obj = aDecoder.decodeObject(forKey: "packageType") as? String {
            self.packageType = obj
        }
        
        self.id = aDecoder.decodeCInt(forKey: "id")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(contentType, forKey: "contentType")
        aCoder.encode(dataKey, forKey: "dataKey")
        aCoder.encode(dataType, forKey: "dataType")
        aCoder.encode(customData, forKey: "customData")
        aCoder.encode(packageType, forKey: "packageType")
        aCoder.encode(id, forKey: "id")
    }
    
    public init(_ json : [String : Any]){
        super.init()
        contentType = getString(value: json["contentType"])
        dataKey = getString(value: json["dataKey"])
        dataType = getString(value: json["dataType"])
        customData = getString(value: json["customData"])
        packageType = getString(value: json["packageType"])
        id = Int32(getInt(value: json["id"]))
    }
}

public class CloseCaptions: YuppModel {
    
    public var ccList = [CCData]()
    public var defaultLang = ""
    public var loadDefault = ""

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        ccList = CloseCaptions.ccList(json: json["ccList"])
        defaultLang = getString(value: json["defaultLang"])
        loadDefault = getString(value: json["loadDefault"])
    }
    
    public static func ccList(json : Any?) -> [CCData]{
        var list = [CCData]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(CCData(obj))
            }
        }
        return list
    }
}

public class CCData: YuppModel {
    public var language = ""
    public var filePath = ""
    public var fileType = ""
    
    public init(_ json : [String : Any]){
        super.init()
        language = getString(value: json["language"])
        filePath = getImageUrl(value: json["filePath"])
        fileType = getString(value: json["fileType"])
    }
}

public class SessionInfo: YuppModel {
    public var pollIntervalInMillis = 0
    public var streamPollKey = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        pollIntervalInMillis = getInt(value: json["pollIntervalInMillis"])
        streamPollKey = getString(value: json["streamPollKey"])
    }
}

public class StreamActiveSession: YuppModel {
    
    public var deviceName = ""
    public var deviceIconUrl = ""
    public var lastUpdatedTime : NSNumber = 0
    public var userLocation = UserLocation()
    public var boxId = ""
    public var tenantCode = ""
    public var streamPollKey = ""
    public var deviceSubtype = ""
    public var deviceId = -1
    public var appSessionId = ""
    public var productCode = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        deviceName = getString(value: json["deviceName"])
        deviceIconUrl = getImageUrl(value:json["deviceIconUrl"])
        lastUpdatedTime = getNSNumber(value: json["lastUpdatedTime"])
        if let json = json["userLocation"] as? [String : Any]{
            userLocation = UserLocation.init(json)
        }
        boxId = getString(value: json["boxId"])
        tenantCode = getString(value: json["tenantCode"])
        streamPollKey = getString(value: json["streamPollKey"])
        deviceSubtype = getString(value: json["deviceSubtype"])
        deviceId = getInt(value: json["deviceId"])
        appSessionId = getString(value: json["appSessionId"])
        productCode = getString(value: json["productCode"])
    }
    
    public static func array(json : Any?) -> [StreamActiveSession]{
        var list = [StreamActiveSession]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(StreamActiveSession(obj))
            }
        }
        return list
    }
    
}

public class UserLocation: YuppModel {
    
    public var city = ""
    public var continentCode = ""
    public var ip = ""
    public var state = ""
    public var timezone = ""
    public var country = ""
    public var postalCode = ""
    public var repCountryCode = ""
    public var countryCode = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        city = getString(value: json["city"])
        continentCode = getString(value: json["continentCode"])
        ip = getString(value: json["ip"])
        state = getString(value: json["state"])
        timezone = getString(value: json["timezone"])
        country = getString(value: json["country"])
        postalCode = getString(value: json["postalCode"])
        repCountryCode = getString(value: json["repCountryCode"])
        countryCode = getString(value: json["countryCode"])
    }
}
