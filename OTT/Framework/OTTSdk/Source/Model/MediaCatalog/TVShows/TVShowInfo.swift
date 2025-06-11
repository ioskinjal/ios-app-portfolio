//
//  TVShowInfo.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 05/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class TVShowInfo: NSObject {
    public var subtitle = ""
    public var isOriginal = false
    public var name = ""
    public var genre = ""
    public var backgroundImage = ""
    public var infoDescription = ""
    public var channelName = ""
    public var episodesCount = 0
    public var telecastDate : NSNumber = 0
    public var code = ""
    public var langCode = ""
    public var id = 0
    public var language = ""
    public var rating = 0
    public var subtitles = false
    public var hd = false
    public var action = ""
    public var iconUrl = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        subtitle = Utility.getStringValue(value: json["subtitle"])
        isOriginal = Utility.getBoolValue(value: json["isOriginal"])
        name = Utility.getStringValue(value: json["name"])
        genre = Utility.getStringValue(value: json["genre"])
        backgroundImage = Utility.getStringValue(value: json["backgroundImage"])
        infoDescription = Utility.getStringValue(value: json["description"])
        episodesCount = Utility.getIntValue(value: json["episodesCount"])
        telecastDate = Utility.getNSNumberValue(value: json["telecastedDate"])
        code = Utility.getStringValue(value: json["code"])
        language = Utility.getStringValue(value: json["language"])
        rating = Utility.getIntValue(value: json["rating"])
        subtitles = Utility.getBoolValue(value: json["subtitles"])
        hd = Utility.getBoolValue(value: json["hd"])
        action = Utility.getStringValue(value: json["action"])
        iconUrl = Utility.getStringValue(value: json["iconUrl"])
    }
}
