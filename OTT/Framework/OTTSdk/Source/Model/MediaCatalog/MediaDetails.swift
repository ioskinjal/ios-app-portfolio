//
//  MediaDetails.swift
//  YuppTV
//
//  Created by Muzaffar on 15/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class MediaDetails: NSObject {
    public var isSubscribed = true
    public var previewDuration = 0
    public var message = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        isSubscribed = Utility.getBoolValue(value: jsonObj["isSubscribed"])
        previewDuration = Utility.getIntValue(value: jsonObj["previewDuration"])
        message = Utility.getStringValue(value: jsonObj["message"])
    }

}
