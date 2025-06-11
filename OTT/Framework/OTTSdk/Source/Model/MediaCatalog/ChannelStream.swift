//
//  ChannelStream.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 06/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ChannelStream: NSObject {
    
    public var sType = ""
    public var streamUrl = ""
    public var vttPath = ""
    public var adDetails = AdDetails()
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        sType = Utility.getStringValue(value: json["sType"])
        streamUrl = Utility.getStringValue(value: json["streamUrl"])
        vttPath = Utility.getStringValue(value: json["vttPath"])
        if let _adDetails = json["adDetails"] as? [String : Any]{
            adDetails = AdDetails.init(withJSON: _adDetails)
        }
    }
    
    public static func streamList(json : [[String : Any]]) -> [ChannelStream]{
        var list = [ChannelStream]()
        for obj in json {
            list.append(ChannelStream.init(withJSON: obj))
        }
        return list
    }
}
