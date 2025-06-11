//
//  ActiveDevice.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 16/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ActiveDevice: NSObject, NSCoding {

    var box = ""
    var deviceType = 0
    
    internal override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let box = aDecoder.decodeObject(forKey: "box") as? String {
            self.box = box
        }
        if let deviceType = aDecoder.decodeObject(forKey: "deviceType") as? Int {
            self.deviceType = deviceType
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(box, forKey: "box")
        aCoder.encode(deviceType, forKey: "deviceType")
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        box = Utility.getStringValue(value: json["box"])
        deviceType = Utility.getIntValue(value: json["deviceType"])
    }
    
    public static func deviceList(json : [[String : Any]]) -> [ActiveDevice]{
        var list = [ActiveDevice]()
        for obj in json {
            list.append(ActiveDevice.init(withJSON: obj))
        }
        return list
    }
}
