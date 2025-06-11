//
//  ButtonInfo.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 19/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ButtonInfo: NSObject {

    
    
     public var showButton = false
     public var text = ""
     public var actionType = 0
     public var action = ""
     
    
    internal override init() {
        super.init()
    }
    
    internal init(withJson json: Any?){
        super.init()
        guard let _json = json as? [String : Any] else {
            return
        }
        showButton = Utility.getBoolValue(value: _json["showButton"])
        text = Utility.getStringValue(value: _json["text"])
        actionType = Utility.getIntValue(value: _json["actionType"])
        action = Utility.getStringValue(value: _json["action"])
    }
}
