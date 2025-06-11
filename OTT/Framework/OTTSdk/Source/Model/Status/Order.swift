//
//  Order.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 19/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Order: NSObject {
    
    public var orderDate :NSNumber = 0
    public var orderId = 0
    public var price : Float = 0
    public var packageName = ""
    public var payMode = ""
    public var currency = ""
   
    internal init(withJson json: [String : Any]){
        super.init()
        orderDate = Utility.getNSNumberValue(value: json["orderDate"])
        orderId = Utility.getIntValue(value: json["orderId"])
        price = Utility.getFloatValue(value: json["price"])
        packageName = Utility.getStringValue(value: json["packageName"])
        payMode = Utility.getStringValue(value: json["payMode"])
        currency = Utility.getStringValue(value: json["currency"])
        
    }
    
    internal static func ordersList(json : Any?) -> [Order]{
        var list = [Order]()
        if let objJson = json as? [[String : Any]]{
            for obj in objJson {
                list.append(Order.init(withJson: obj))
            }
        }
        return list
    }
    
}
