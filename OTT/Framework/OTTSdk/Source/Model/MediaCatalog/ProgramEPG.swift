//
//  ProgramEPG.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 18/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ProgramEPG: NSObject {
    public var name = ""
    public var genre = ""
    public var startTime : NSNumber = 0
    public var epgDescription = ""
    public var genreCode = ""
    public var code = ""
    public var endTime : NSNumber = 0
    public var langCode = ""
    public var epgId = 0
    public var views = 0
    public var subGenre = ""
    public var lang = ""
    public var imageUrl = ""
    public var channelId = 0
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        name = Utility.getStringValue(value: json["name"])
        genre = Utility.getStringValue(value: json["genre"])
        startTime = Utility.getNSNumberValue(value: json["startTime"])
        epgDescription = Utility.getStringValue(value: json["description"])
        genreCode = Utility.getStringValue(value: json["genreCode"])
        code = Utility.getStringValue(value: json["code"])
        endTime = Utility.getNSNumberValue(value: json["endTime"])
        langCode = Utility.getStringValue(value: json["langCode"])
        epgId = Utility.getIntValue(value: json["id"])
        views = Utility.getIntValue(value: json["views"])
        subGenre = Utility.getStringValue(value: json["subGenre"])
        lang = Utility.getStringValue(value: json["lang"])
        imageUrl = Utility.getStringValue(value: json["imageUrl"])
        channelId = Utility.getIntValue(value: json["channelId"])
    }
    
    public static func epgList(json : [[String : Any]]) -> [ProgramEPG]{
        var list = [ProgramEPG]()
        for obj in json {
            list.append(ProgramEPG.init(withJSON: obj))
        }
        return list
    }
}
