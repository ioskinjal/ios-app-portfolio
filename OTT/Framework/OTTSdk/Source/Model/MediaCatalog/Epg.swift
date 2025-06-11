//
//  Epg.swift
//  YuppTV
//
//  Created by Muzaffar on 12/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Epg: NSObject {
    
    public var programImageUrl = ""
    public var count = 0
    public var programGenre = ""
    public var channelDescription = ""
    public var programStartTime : NSNumber = 0
    public var channelName = ""
    public var programCode = ""
    public var programName = ""
    public var langCode = ""
    public var channelCode = ""
    public var programEndTime : NSNumber = 0
    public var programId = 0
    public var views = 0
    public var programSubgenre = ""
    public var isPremium = true
    public var lang = ""
    public var channelId = -1
    public var iconUrl = ""
    public var programGenreCode = ""
    
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        programImageUrl = Utility.getStringValue(value: json["programImageUrl"])
        count = Utility.getIntValue(value: json["count"])
        programGenre = Utility.getStringValue(value: json["programGenre"])
        channelDescription = Utility.getStringValue(value: json["description"])
        programStartTime = Utility.getNSNumberValue(value: json["programStartTime"])
        channelName = Utility.getStringValue(value: json["channelName"])
        programCode = Utility.getStringValue(value: json["programCode"])
        programName = Utility.getStringValue(value: json["programName"])
        langCode = Utility.getStringValue(value: json["langCode"])
        channelCode = Utility.getStringValue(value: json["channelCode"])
        programEndTime = Utility.getNSNumberValue(value: json["programEndTime"])
        programId = Utility.getIntValue(value: json["programId"])
        views = Utility.getIntValue(value: json["views"])
        programSubgenre = Utility.getStringValue(value: json["programSubgenre"])
        isPremium = Utility.getBoolValue(value: json["isPremium"])
        lang = Utility.getStringValue(value: json["lang"])
        channelId = Utility.getIntValue(value: json["channelId"])
        iconUrl = Utility.getStringValue(value: json["iconUrl"])
        programGenreCode = Utility.getStringValue(value: json["programGenreCode"])
    }
    
    public static func channelList(json : Any) -> [Epg]{
        var list = [Epg]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Epg.init(withJSON: obj))
            }
        }
        return list
    }
    
}
