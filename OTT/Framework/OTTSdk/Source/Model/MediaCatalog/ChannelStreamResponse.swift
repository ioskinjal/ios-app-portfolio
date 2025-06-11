//
//  ChannelStreamResponse.swift
//  YuppTV
//
//  Created by Muzaffar on 15/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ChannelStreamResponse: NSObject {

    public var isMultiPartStream = false
    public var streams = [ChannelStream]()
    public var isUserLoggedIn = false
    public var mediaDetails = MediaDetails()
    public var menus = [Menu]()
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        isMultiPartStream = Utility.getBoolValue(value: json["isMultiPartStream"])
        if let _streams = json["streams"] as? [[String : Any]]{
            streams = ChannelStream.streamList(json:_streams)
        }
        isUserLoggedIn = Utility.getBoolValue(value: json["isUserLoggedIn"])
        mediaDetails = MediaDetails.init(withJSON: json["mediaDetails"])
        if let _menus = json["menus"] as? [[String : Any]]{
            menus = Menu.menuList(json: _menus)
        }
    }
}
