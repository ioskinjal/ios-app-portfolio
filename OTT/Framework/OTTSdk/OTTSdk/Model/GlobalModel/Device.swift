//
//  Device.swift
//  OTTSdk
//
//  Created by Muzaffar on 14/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Device: YuppModel {
    
    public var boxId = ""
    public var deviceId = 0
    public var isCurrentDevice = false
    public var loggedinTime : NSNumber = 0
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        boxId = getString(value: json["boxId"])
        deviceId = getInt(value:json["deviceId"])
        isCurrentDevice = getBool(value:json["isCurrentDevice"])
        loggedinTime = getNSNumber(value:json["loggedinTime"])
    }
    
    public static func array(json : Any?) -> [Device]{
        var list = [Device]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Device(obj))
            }
        }
        return list
    }
    
}
