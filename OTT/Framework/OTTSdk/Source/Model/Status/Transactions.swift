//
//  Transactions.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 19/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Transactions: NSObject {
    public var orders = [Order]()
    public var headerText = ""
    
    internal init(withJson json: [String : Any]){
        super.init()
        orders = Order.ordersList(json: json["orders"])
        headerText = Utility.getStringValue(value: json["headerText"])
    }
}
