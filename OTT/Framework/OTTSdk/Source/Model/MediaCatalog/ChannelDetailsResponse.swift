//
//  ChannelDetailsResponse.swift
//  YuppTV
//
//  Created by Muzaffar on 12/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ChannelDetailsResponse: NSObject {
    public var channel = Channel()
    public var menus = [Menu]()
    public var programs = [Program]()
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        
        if let channelInfo = json["channel"] as? [String : Any]{
            channel = Channel.init(withJSON: channelInfo)
        }
        
        if let channelInfo = json["menus"] as? [[String : Any]]{
            menus = Menu.menuList(json: channelInfo)
        }
        
        if let programsInfo = json["programs"] as? [[String : Any]]{
            programs = Program.programEpgList(json: programsInfo)
        }
        
    }
    
    public static func channelDetailsResponseList(json : [[String : Any]]) -> [ChannelDetailsResponse]{
        var list = [ChannelDetailsResponse]()
        for obj in json {
            list.append(ChannelDetailsResponse.init(withJSON: obj))
        }
        return list
    }
}
