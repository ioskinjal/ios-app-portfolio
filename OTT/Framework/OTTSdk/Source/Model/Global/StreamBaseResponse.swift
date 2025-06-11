//
//  StreamBaseResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 01/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class StreamBaseResponse: NSObject {
    public var status  = 0
    public var data  = ""
    
    public override init() {
        super.init()
    }
    
    public init(withResponse json: [String : Any]){
        super.init()
        status = Utility.getIntValue(value: json["status"])
        data = Utility.getStringValue(value: json["data"])
    }
}
