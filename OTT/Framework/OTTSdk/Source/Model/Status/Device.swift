//
//  Device.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 19/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Device: NSObject {

    public var subtitle = ""
    public var boxId = ""
    public var deviceType = 0
    public var buttonInfo = ButtonInfo()
    public var title = ""
    public var imageUrl = ""
    
   
    internal override init() {
        super.init()
    }
    
    internal init(withJson json: [String : Any]){
        super.init()
        subtitle = Utility.getStringValue(value: json["subtitle"])
        boxId = Utility.getStringValue(value: json["boxId"])
        deviceType = Utility.getIntValue(value: json["deviceType"])
        buttonInfo = ButtonInfo.init(withJson: json["buttonInfo"])
        title = Utility.getStringValue(value: json["title"])
        imageUrl = Utility.getStringValue(value: json["imageUrl"])
        
    }
    
    public static func devicesList(json : Any?) -> [Device]{
        var list = [Device]()
        if let objJson = json as? [[String : Any]]{
            for obj in objJson {
                list.append(Device.init(withJson: obj))
            }
        }
        return list
    }
    
}
