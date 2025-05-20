//
//  Notifications.swift
//  BooknRide
//
//  Created by KASP on 27/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class Notifications: NSObject {

   var notificationDateTime = "";
   var notificationId = ""; // Int
   var notifyCategory = "";
   var notifyMessage = "";
   var notifyType = "";
   var rideId = ""; // Int
   var status = "";
   var user2Id = "";
   var constantValue = ""
    
//    notificationDateTime = "26 Dec, 2017 13:16";
//    notificationId = 267;
//    notifyCategory = "ride_book";
//    notifyMessage = "Ride booked successfully";
//    notifyType = s;
//    rideId = 116;
//    status = r;
//    user2Id = "";
    
    class func initWithResponse(array:[Any]?) -> [Notifications]{
        
        var allNotifications = [Notifications]()
        
        
        guard let tempArray = array else { return [Notifications]() }
        
        
        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let notification = Notifications()
            
            
            if valid.isNotNull(object: item.object(forKey: "notificationDateTime") as AnyObject){
                notification.notificationDateTime = String(format:"%@",item.object(forKey: "notificationDateTime") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "notificationId") as AnyObject){
                notification.notificationId = "\(item.object(forKey: "notificationId") ?? "")"
            }
            
            if valid.isNotNull(object: item.object(forKey: "notifyCategory") as AnyObject){
                notification.notifyCategory = String(format:"%@",item.object(forKey: "notifyCategory") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "notifyMessage") as AnyObject){
                notification.notifyMessage = String(format:"%@",item.object(forKey: "notifyMessage") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "notifyType") as AnyObject){
                notification.notifyType = String(format:"%@",item.object(forKey: "notifyType") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "rideId") as AnyObject){
                notification.rideId = "\(item.object(forKey: "rideId") ?? "")"
            
            }
            
            if valid.isNotNull(object: item.object(forKey: "status") as AnyObject){
                notification.status = String(format:"%@",item.object(forKey: "status") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "user2Id") as AnyObject){
                notification.user2Id = "\(item.object(forKey: "user2Id") ?? "")"
            }
            
            if valid.isNotNull(object: item.object(forKey: "constantValue") as AnyObject){
                notification.constantValue = "\(item.object(forKey: "constantValue") ?? "")"
            }
            
            allNotifications.append(notification)
            
        }
        
        
        return allNotifications
    }
    
    
}
