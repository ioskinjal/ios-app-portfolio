//
//  UpdateAddressResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 17/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class UpdateAddressResponse: NSObject {
    public var billingAddress = Address()
    public var shippingAddress = Address()
    
    internal init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        billingAddress = Address.init(withJSON: jsonObj["billingAddress"])
        shippingAddress = Address.init(withJSON: jsonObj["shippingAddress"])
    }
}
