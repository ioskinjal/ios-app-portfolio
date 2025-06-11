//
//  OTP.swift
//  YuppTV
//
//  Created by Muzaffar on 09/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class OTP: BaseResponse {
    
    public init(withJson response: [String : Any]) {
        super.init()
        message = Utility.getStringValue(value: response["message"])
    }
    
}
