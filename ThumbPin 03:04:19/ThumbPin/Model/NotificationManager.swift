//
//  NotificationManager.swift
//  LimingTree
//
//  Created by NCrypted on 02/07/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

enum ActionKey:String {
    case none = "None"
    case message = "Message"
}


class NotificationManager: NSObject {
    
    var actionType = ActionKey.none
    
    var title:String?
    var body:String?
    var customerId:Int?
    var key:String?
    var pkg:String?
    var providerId:Int?
    var quoteId:Int?
    var serviceId:Int?
    var serviceIdService:String?
    
    override init() {
        
    }
    
    init(notification:NSDictionary){
        
        if (notification.object(forKey: "aps") != nil){
            
            let apsDict = notification.object(forKey: "aps") as? [String:Any]
            
            print(apsDict)
            
            if (apsDict!["alert"] != nil) &&  (apsDict!["data"] != nil){
                
                let alertDict = apsDict!["alert"] as? [String:Any]
                let datatDict = apsDict!["data"] as? [String:Any]
                
                self.title = alertDict!["title"] as? String ?? ""
                self.body = alertDict!["body"] as? String ?? ""
                self.key = datatDict!["key"] as? String ?? ""
                
                if key == "Message" {
                    self.customerId = datatDict!["customerId"] as? Int ?? 0
                    self.pkg = datatDict!["pkg"] as? String ?? ""
                    self.providerId = datatDict!["providerId"] as? Int ?? 0
                    self.quoteId = datatDict!["quoteId"] as? Int ?? 0
                    self.serviceId = datatDict!["serviceId"] as? Int ?? 0
                }
                else if key == "Service" {
                    self.pkg = datatDict!["pkg"] as? String ?? ""
                    self.serviceIdService = datatDict!["serviceId"] as? String ?? ""
                }
                else if key == "Quote" {
                    self.pkg = datatDict!["pkg"] as? String ?? ""
                    self.serviceId = datatDict!["serviceId"] as? Int ?? 0
                }
            }
        }
    }
}





