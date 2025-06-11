//
//  LinkedDevicesResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 19/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class LinkedDevicesResponse: NSObject {
    public var devices = [Device]()
    public var headerText = ""
    public var linkedDevicesDescription = ""
    public var buttonInfo =  ButtonInfo()
    
    internal init(withJson json: [String : Any]){
        super.init()
        devices = Device.devicesList(json: json["devices"])
        headerText = Utility.getStringValue(value: json["headerText"])
        linkedDevicesDescription = Utility.getStringValue(value: json["description"])
        buttonInfo = ButtonInfo.init(withJson: json["buttonInfo"])
    }
  
    public static func devicesList(json : Any?) -> [LinkedDevicesResponse]{
        var list = [LinkedDevicesResponse]()
        if let objJson = json as? [[String : Any]]{
            for obj in objJson {
                list.append(LinkedDevicesResponse.init(withJson: obj))
            }
        }
        return list
    }
}
