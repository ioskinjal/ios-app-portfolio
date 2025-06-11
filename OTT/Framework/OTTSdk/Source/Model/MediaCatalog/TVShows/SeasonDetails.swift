//
//  SeasonDetails.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 05/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class SeasonDetails: NSObject {
    public var subtitle = ""
    public var backgroundImage = ""
    public var seasonDetailsDescription = ""
    public var episodesCount = 0
    public var trailerUrl = ""
    public var seasonId = 0
    public var rating = 0
    public var title = ""
    public var telecastedDate : NSNumber = 0
    public var action = ""
    public var iconUrl = ""
    
   
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        subtitle = Utility.getStringValue(value: json["subtitle"])
        backgroundImage = Utility.getStringValue(value: json["backgroundImage"])
        seasonDetailsDescription = Utility.getStringValue(value: json["description"])
        episodesCount = Utility.getIntValue(value: json["episodesCount"])
        trailerUrl = Utility.getStringValue(value: json["trailerUrl"])
        seasonId = Utility.getIntValue(value: json["id"])
        rating = Utility.getIntValue(value: json["rating"])
        title = Utility.getStringValue(value: json["title"])
        telecastedDate = Utility.getNSNumberValue(value: json["telecastedDate"])
        action = Utility.getStringValue(value: json["action"])
        iconUrl = Utility.getStringValue(value: json["iconUrl"])
    }
}
