//
//  TVShow.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 18/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class TVShow: NSObject {
    
    public var action = ""
    public var backgroundImage = ""
    public var channelName = ""
    public var code = ""
    public var tvShowDescription  = ""
    public var episodesCount = 0
    public var genre = ""
    public var hd = false
    public var iconUrl = ""
    public var tvShowId = 0
    public var isOriginal = false
    public var langCode = ""
    public var language = ""
    public var name = ""
    public var rating = 0
    public var subtitle = ""
    public var subtitles = false
    public var telecastDate : NSNumber = 0
    
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        
        
        action = Utility.getStringValue(value: jsonObj["action"])
        backgroundImage = Utility.getStringValue(value: jsonObj["backgroundImage"])
        channelName = Utility.getStringValue(value: jsonObj["channelName"])
        code = Utility.getStringValue(value: jsonObj["code"])
        tvShowDescription = Utility.getStringValue(value: jsonObj["description"])
        episodesCount = Utility.getIntValue(value: jsonObj["episodesCount"])
        genre = Utility.getStringValue(value: jsonObj["genre"])
        hd = Utility.getBoolValue(value: jsonObj["hd"])
        iconUrl = Utility.getStringValue(value: jsonObj["iconUrl"])
        tvShowId = Utility.getIntValue(value: jsonObj["id"])
        isOriginal = Utility.getBoolValue(value: jsonObj["isOriginal"])
        langCode = Utility.getStringValue(value: jsonObj["langCode"])
        language = Utility.getStringValue(value: jsonObj["language"])
        name = Utility.getStringValue(value: jsonObj["name"])
        rating = Utility.getIntValue(value: jsonObj["rating"])
        subtitle = Utility.getStringValue(value: jsonObj["subtitle"])
        subtitles = Utility.getBoolValue(value: jsonObj["subtitles"])
        telecastDate = Utility.getNSNumberValue(value: jsonObj["telecastDate"])
        
    }
    
    public static func tvShowList(json : [[String : Any]]) -> [TVShow]{
        var list = [TVShow]()
        for object in json {
            list.append(TVShow.init(withJSON: object))
        }
        return list
    }
    
}
