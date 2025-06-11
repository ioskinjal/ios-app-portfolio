//
//  BaseResponse.swift
//  YuppTV
//
//  Created by Muzaffar on 10/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class BaseResponse: NSObject {
    public var message  = ""
    
    public override init() {
        super.init()
    }
    
    public init(withResponse json: [String : Any]){
        super.init()
        message = Utility.getStringValue(value: json["message"])
    }
}
