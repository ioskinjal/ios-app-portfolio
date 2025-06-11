//
//  Address.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 17/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Address: NSObject {
   
    public var address = ""
    public var address2 = ""
    public var address3 = ""
    public var city = ""
    public var state = ""
    public var country = ""
    public var zipCode = ""
    
    internal override init() {
        super.init()
    }
    
    public init(address1 address : String, address2 : String, address3 : String, city : String, state : String, country : String, zipCode : String){
        super.init()
        self.address = address
        self.address2 = address2
        self.address3 = address3
        self.city = city
        self.state = state
        self.country = country
        self.zipCode = zipCode
    }
    
    internal init(withJSON json : Any?){
        super.init()
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        self.address = Utility.getStringValue(value: jsonObj["address"])
        self.address2 = Utility.getStringValue(value: jsonObj["address2"])
        self.address3 = Utility.getStringValue(value: jsonObj["address3"])
        self.city = Utility.getStringValue(value: jsonObj["city"])
        self.state = Utility.getStringValue(value: jsonObj["state"])
        self.country = Utility.getStringValue(value: jsonObj["country"])
        self.zipCode = Utility.getStringValue(value: jsonObj["zipCode"])
    }
    
    internal func dictionary() -> [String : Any] {
        return ["address" : self.address,
                "address2" : self.address2,
                "address3" : self.address3,
                "city" : self.city,
                "state" : self.state,
                "country" : self.country,
                "zipCode" : self.zipCode
        ]
    }
}
