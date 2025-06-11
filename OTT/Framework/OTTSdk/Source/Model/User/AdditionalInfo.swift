//
//  AdditionalInfo.swift
//  YuppTV
//
//  Created by Muzaffar on 10/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class AdditionalInfo: NSObject {
    public var message = ""
    public var code = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJson json: [String : Any]){
        super.init()
        message = Utility.getStringValue(value: json["message"])
        code = Utility.getStringValue(value: json["code"])
    }
}
