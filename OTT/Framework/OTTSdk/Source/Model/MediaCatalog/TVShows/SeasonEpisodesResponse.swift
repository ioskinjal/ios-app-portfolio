//
//  SeasonEpisodesResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 06/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class SeasonEpisodesResponse: NSObject {
    public var count = 0
    public var lastIndex = -1
    public var episodes = [Episode]()
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        count = Utility.getIntValue(value: json["count"])
        lastIndex = Utility.getIntValue(value: json["lastIndex"])
        if let _episodes =  json["episodes"] as? [[String : Any]]{
            episodes = Episode.episodesList(json: _episodes)
        }
    }
}
