//
//  VerifyOTPResponse.swift
//  YuppTV
//
//  Created by Muzaffar on 10/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class VerifyOTPResponse: BaseResponse {

    public var nextPage : NextPage?
    
    public init(withJson json: [String : Any]){
        super.init()
        message = Utility.getStringValue(value: json["message"])
        nextPage = NextPage.init(withJson: json["nextPage"] as! [String : Any])
    }
}
