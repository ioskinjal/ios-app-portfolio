//
//  OTP.swift
//  OTTSdk
//
//  Created by Muzaffar on 19/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class OTP: YuppModel {
    public var message = ""
    public var referenceId = 0
    public var statusCode = -1
    public var context = ""
    public var target = ""
    public var targetType = ""
    public var showOTPScreen = false
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        message = getString(value:json["message"])
        referenceId = getInt(value:json["referenceId"])
        statusCode = getInt(value:json["statusCode"])
        context = getString(value:json["context"])
        target = getString(value:json["target"])
        targetType = getString(value:json["targetType"])
        showOTPScreen = getBool(value: json["showOTPScreen"])
    }
}
