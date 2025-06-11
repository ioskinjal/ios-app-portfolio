//
//  Transaction.swift
//  OTTSdk
//
//  Created by Muzaffar on 21/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit
import CoreGraphics

public class Transaction: YuppModel {
    /*
     "orderId": "1DFIFDQ21C6ONOEQSJ",
     "packageName": "1",
     "expiryTime": 1502966827729,
     "amount": 90,
     "status": "P",
     "currency": "SHL",
     "message": "In Progress",
     "purchaseTime": 1500288427729,
     "gateway":"mpesa"
     */
    public var orderId = ""
    public var packageName = ""
    public var expiryTime : NSNumber = 0
    public var amount : String = "0.0"
    public var status = ""
    public var currency = ""
    public var message = ""
    public var purchaseTime : NSNumber = 0
    public var gateway = ""
    public var tax : String = "0.0"
    public var totalAmount : String = "0.0"

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.ceiling
        formatter.maximumFractionDigits = 2
        
        orderId = getString(value: json["orderId"])
        packageName = getString(value:json["packageName"])
        expiryTime = getNSNumber(value:json["expiryTime"])
        amount = formatter.string(for: getDouble(value:json["amount"]))!
        tax = formatter.string(for: getDouble(value:json["tax"]))!
        totalAmount = formatter.string(for: getDouble(value:json["totalAmount"]))!
        status = getString(value:json["status"])
        currency = getString(value:json["currency"])
        message = getString(value:json["message"])
        purchaseTime = getNSNumber(value:json["purchaseTime"])
        gateway = getString(value:json["gateway"])
    }
    
    public static func array(json : Any?) -> [Transaction]{
        var list = [Transaction]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Transaction(obj))
            }
        }
        return list
    }
}
