//
//  Episode.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 16/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Episode: NSObject {
    
    public var tvShowName = ""
    public var number = 0
    public var subtitle = ""
    public var name = ""
    public var genre = ""
    public var episodeDescription = ""
    public var seasonNumber = 0
    public var hasDrm = false
    public var telecastDate : NSNumber = 0
    public var tvShowId = 0
    public var langCode = ""
    public var episodeId = 0
    public var language = ""
    public var payType = ""
    public var seasonId = 0
    public var action = ""
    public var iconUrl = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        
        tvShowName = Utility.getStringValue(value: jsonObj["tvShowName"])
        number = Utility.getIntValue(value: jsonObj["number"])
        subtitle = Utility.getStringValue(value: jsonObj["subtitle"])
        name = Utility.getStringValue(value: jsonObj["name"])
        genre = Utility.getStringValue(value: jsonObj["genre"])
        episodeDescription = Utility.getStringValue(value: jsonObj["description"])
        seasonNumber = Utility.getIntValue(value: jsonObj["seasonNumber"])
        hasDrm = Utility.getBoolValue(value: jsonObj["hasDrm"])
        telecastDate = Utility.getNSNumberValue(value: jsonObj["telecastDate"])
        tvShowId = Utility.getIntValue(value: jsonObj["tvShowId"])
        langCode = Utility.getStringValue(value: jsonObj["langCode"])
        episodeId = Utility.getIntValue(value: jsonObj["id"])
        language = Utility.getStringValue(value: jsonObj["language"])
        payType = Utility.getStringValue(value: jsonObj["payType"])
        seasonId = Utility.getIntValue(value: jsonObj["seasonId"])
        action = Utility.getStringValue(value: jsonObj["action"])
        iconUrl = Utility.getStringValue(value: jsonObj["iconUrl"])
    }
    
    public static func episodesList(json : [[String : Any]]) -> [Episode]{
        var list = [Episode]()
        for object in json {
            list.append(Episode.init(withJSON: object))
        }
        return list
    }
}
