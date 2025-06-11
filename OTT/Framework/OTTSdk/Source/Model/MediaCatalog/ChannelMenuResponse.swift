//
//  ChannelMenuResponse.swift
//  YuppTV
//
//  Created by Muzaffar on 12/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

/// ChannelMenuResponse holds the list of channels in data varialbe.
public class ChannelMenuResponse: NSObject {
    public var name = ""
    public var count = 0
    public var data = [Channel]()
    public var code = ""
    public var lastIndex = 0
    public var lang = ""
    public var dataType = ""
    
    /*
     "name": "OneOffs this week",
     "count": 4,
     "data": [],
     "code": "oneoffs",
     "lastIndex": 4,
     "lang": "",
     "dataType": "epg"
     
     */
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        name = Utility.getStringValue(value: json["name"])
        count = Utility.getIntValue(value: json["count"])
        if let _data = json["data"] as? [[String : Any]]{
            data = Channel.channelList(json: _data)
        }
        code = Utility.getStringValue(value: json["code"])
        lastIndex = Utility.getIntValue(value: json["lastIndex"])
        lang = Utility.getStringValue(value: json["lang"])
        dataType = Utility.getStringValue(value: json["dataType"])
    }
    
    public static func menuList(json : [[String : Any]]) -> [ChannelMenuResponse]{
        var list = [ChannelMenuResponse]()
        for obj in json {
            list.append(ChannelMenuResponse.init(withJSON: obj))
        }
        return list
    }
}
