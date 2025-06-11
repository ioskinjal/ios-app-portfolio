//
//  AccountDetails.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 17/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class AccountDetails: NSObject {

    public var email = ""
    public var isEmailVerified = false
    public var billingAddress = Address()
    public var activePackages = [ActivePackages]()
    public var isCardVerified = false
    public var isActive = false
    public var registrationDate : NSNumber = 0
    public var shippingAddress = Address()
    public var mobile = ""
    public var cardNumber = ""
    public var password = ""
    public var isMobileVerified = false
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        email = Utility.getStringValue(value: json["email"])
        isEmailVerified = Utility.getBoolValue(value: json["isEmailVerified"])
        billingAddress = Address.init(withJSON: json["billingAddress"])
        activePackages = ActivePackages.packagesList(json: json["activePackages"])
        isCardVerified = Utility.getBoolValue(value: json["isCardVerified"])
        isActive = Utility.getBoolValue(value: json["isActive"])
        registrationDate = Utility.getNSNumberValue(value: json["registrationDate"])
        shippingAddress = Address.init(withJSON: json["shippingAddress"])
        mobile = Utility.getStringValue(value: json["mobile"])
        cardNumber = Utility.getStringValue(value: json["cardNumber"])
        password = Utility.getStringValue(value: json["password"])
        isMobileVerified = Utility.getBoolValue(value: json["isMobileVerified"])
    }
}
