//
//  NotificationManager.swift
//  BooknRide
//
//  Created by KASP on 10/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

enum RedirectAction:Int {
    
    case none = 0
    case fareEstimate = 1
    case rideInfo = 2
    case cancelride = 3
    case rideStarted = 4
    case driverArrived = 5

}

enum DeepLinkType:Int{
    
    case data = 1
    case notification = 2
    
}

class NotificationManager: NSObject {
    
    var deeplinkType: DeepLinkType?
    var actionType = RedirectAction.none
    
    var message:String?
    var title:String?
    
    var rideId:String?
    var driverId:String?
    var carId:String?
    var totalTime:String?
    var perMinFareAmount:String?
    
    
    override init() {
        
    }
    
    class func processDeepLink(notification:NSDictionary) -> NotificationManager {
        
        let manager = NotificationManager()
        
        
        if (notification.object(forKey: "aps") != nil){
            
            let bodyString:String = (notification.object(forKey: "body") as? String)!
            
            let bodyData:NSDictionary = RideUtilities.convertToDictionary(jsonString: bodyString)! as NSDictionary
            
            let type:String = String(format:"%@",bodyData.object(forKey: "type") as! CVarArg)
            
            if type.lowercased() == "data" {
                manager.deeplinkType = .data
                
                let redirectAction:String = String(format:"%@",bodyData.object(forKey: "redirect") as! CVarArg)
                
                if redirectAction == "fareEstimate"{
                    // Show Fare Summary after complete ride
                    manager.actionType = .fareEstimate
                    
                    let dataAns:NSDictionary = (bodyData["dataAns"]! as! NSDictionary)
                    
                    manager.driverId = String(format:"%@",dataAns.object(forKey: "driverId") as! CVarArg)
                    manager.carId = String(format:"%@",dataAns.object(forKey: "carId") as! CVarArg)
                    manager.rideId = String(format:"%@",dataAns.object(forKey: "completedRideId") as! CVarArg)
                    
                    let timeTaken:NSDictionary = (dataAns["timeTaken"]! as! NSDictionary)
                    
                    manager.totalTime = String(format:"%@",timeTaken.object(forKey: "totalTime") as! CVarArg)
                    manager.perMinFareAmount = String(format:"%@",timeTaken.object(forKey: "perMinFareAmount") as! CVarArg)
                    
                    
                }
                else if redirectAction == "rideInfo"{
                    // navigate to RideInfoVC
                    manager.actionType = .rideInfo
                    
                    let dataAns:NSDictionary = (bodyData["dataAns"]! as! NSDictionary)
                    manager.rideId = String(format:"%@",dataAns.object(forKey: "rideId") as! CVarArg)
                    
                }
                else if redirectAction == "cancelride"{
                    // navigate to home.
                    manager.actionType = .cancelride
                    let dataAns:NSDictionary = (bodyData["dataAns"]! as! NSDictionary)
                    manager.rideId = String(format:"%@",dataAns.object(forKey: "canceledRideId") as! CVarArg)
                }
                else if redirectAction == "rideStarted"{
                    // Go To Track.
                    manager.actionType = .rideStarted
                    let dataAns:NSDictionary = (bodyData["dataAns"]! as! NSDictionary)
                    manager.rideId = String(format:"%@",dataAns.object(forKey: "rideId") as! CVarArg)
                }
                else if redirectAction == "driverArrived"{
                    // Show Ride started screen
                    manager.actionType = .driverArrived
                }
            }
            else{
                manager.deeplinkType = .notification
                let message:String = String(format:"%@",bodyData.object(forKey: "message") as! CVarArg)
                manager.message = message
                UserDefaults.standard.setValue("", forKey: "lastSendId")
                UserDefaults.standard.synchronize()
                User.setUserLoginStatus(isLogin: false)
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                appDelegate.rootToLogin()
            }
            
            let notificationTitle:String  = String(format:"%@",notification.object(forKey: "title") as! CVarArg)
            
            manager.title = notificationTitle
        }
        
        return manager
    }
}
