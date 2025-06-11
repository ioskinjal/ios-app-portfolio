//
//  TargetParams.swift
//  YuppTV
//
//  Created by Muzaffar on 11/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class TargetParams: NSObject {
    public var layout = ""
    public var action = ""
    public var code = ""
    public var targetParamsId = ""
    public var url = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        layout = Utility.getStringValue(value: jsonObj["layout"])
        action = Utility.getStringValue(value: jsonObj["action"])
        code = Utility.getStringValue(value: jsonObj["code"])
        targetParamsId = Utility.getStringValue(value: jsonObj["id"])
        url = Utility.getStringValue(value: jsonObj["url"])
    }
}
