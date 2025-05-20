//
//  Wallet.swift
//  BooknRide
//
//  Created by KASP on 22/02/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class Wallet: NSObject {

}

class RedeemHistory : NSObject{
    
   var amount = ""
   var createdDateTime = ""
   var redeemDescription = ""
   var emailAddress = ""
   var historyId = ""
   var status = ""
    
    override init() {
        
    }
    
    class func initWithResponse(array:[Any]?) -> [Any]{
        
        var allHistory = [RedeemHistory]()
        
        
        guard let tempArray = array else { return [RedeemHistory]() }
        
        
        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let history = RedeemHistory()
            
            
            if valid.isNotNull(object: item.object(forKey: "amount") as AnyObject){
                history.amount = String(format:"%@",item.object(forKey: "amount") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "createdDateTime") as AnyObject){
                history.createdDateTime = String(format:"%@",item.object(forKey: "createdDateTime") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "description") as AnyObject){
                history.redeemDescription = String(format:"%@",item.object(forKey: "description") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "emailAddress") as AnyObject){
                history.emailAddress = String(format:"%@",item.object(forKey: "emailAddress") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "id") as AnyObject){
                history.historyId = String(format:"%@",item.object(forKey: "id") as! CVarArg)
            }
            
            if valid.isNotNull(object: item.object(forKey: "status") as AnyObject){
                history.status = String(format:"%@",item.object(forKey: "status") as! NSString)
            }
          
            allHistory.append(history)
            
        }
        
        
        return allHistory
    }
}
