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
    case rideAcceptOrReject = 1
    case startUpdateLatLongWithRideId = 2
    case cancelRide = 3
    
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
    
    var isUrgent:String?
    var rideId:String?
    var customerId:String?
    var carTypeId:String?
    var pickUpLocation:String?
    var pickUpLat:String?
    var pickUpLong:String?
    var dropOffLocation:String?
    var dropOffLat:String?
    var dropOffLong:String?
    var timerLimit:String?
    var tripDateTime:String?
    var logisticCategoryName:String?
    var subTypeName:String?
    var typeName:String?
    var typeImage:String?
    var weight:String?
    var width:String?
    var height:String?
    var breadth:String?
    var number_of_extra_person_required:String?
    
    
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
                
                if let redirectAction:String = bodyData.object(forKey: "redirect") as? String {
                    
                    if redirectAction == "rideAcceptOrReject"{
                        // Show Fare Summary after complete ride
                        manager.actionType = .rideAcceptOrReject
                        
                        let dataAns:NSDictionary = (bodyData["dataAns"]! as! NSDictionary)
                        
                        //  manager.isUrgent = String(format:"%@",dataAns.object(forKey: "isUrgent") as! CVarArg)
                        
                        manager.rideId = String(format:"%@",dataAns.object(forKey: "rideId") as! CVarArg)
                        manager.carTypeId = String(format:"%@",dataAns.object(forKey: "carTypeId") as! CVarArg)
                        
                        manager.customerId = String(format:"%@",dataAns.object(forKey: "customerId") as! CVarArg)
                        
                        manager.pickUpLocation = String(format:"%@",dataAns.object(forKey: "pickUpLocation") as! CVarArg)
                        manager.pickUpLat = String(format:"%@",dataAns.object(forKey: "pickUpLat") as! CVarArg)
                        manager.pickUpLong = String(format:"%@",dataAns.object(forKey: "pickUpLong") as! CVarArg)
                        manager.dropOffLocation = String(format:"%@",dataAns.object(forKey: "dropOffLocation") as! CVarArg)
                        manager.dropOffLat = String(format:"%@",dataAns.object(forKey: "dropOffLat") as! CVarArg)
                        manager.dropOffLong = String(format:"%@",dataAns.object(forKey: "dropOffLong") as! CVarArg)
                        manager.timerLimit = String(format:"%@",dataAns.object(forKey: "timerLimit") as! CVarArg)
                        
                        manager.logisticCategoryName = String(format:"%@",dataAns.object(forKey: "logisticCategoryName") as! CVarArg)
                        manager.typeName = String(format:"%@",dataAns.object(forKey: "typeName") as! CVarArg)
                        manager.subTypeName = String(format:"%@",dataAns.object(forKey: "subTypeName") as! CVarArg)
                        manager.typeImage = String(format:"%@",dataAns.object(forKey: "typeImage") as! CVarArg)
                        manager.weight = String(format:"%@",dataAns.object(forKey: "weight") as! CVarArg)
                        manager.width = String(format:"%@",dataAns.object(forKey: "width") as! CVarArg)
                        manager.height = String(format:"%@",dataAns.object(forKey: "height") as! CVarArg)
                        manager.number_of_extra_person_required = String(format:"%@",dataAns.object(forKey: "number_of_extra_person_required") as! CVarArg)
                        manager.breadth = String(format:"%@",dataAns.object(forKey: "breadth") as! CVarArg)
                        //                    manager.tripDateTime = String(format:"%@",dataAns.object(forKey: "tripDateTime") as! CVarArg)
                    }
                    else if redirectAction == "cancelride"{
                        // navigate to RideInfoVC
                        manager.actionType = .cancelRide
                        
                        //let dataAns:NSDictionary = (bodyData["dataAns"]! as! NSDictionary)
                        
                        DispatchQueue.main.async {
                            UserDefaults.standard.setValue(false, forKey: ParamConstants.Defaults.isRideAccepted)
                            UserDefaults.standard.setValue(false, forKey: ParamConstants.Defaults.isUnderRide)
                            UserDefaults.standard.setValue("", forKey: ParamConstants.Defaults.rideId)
                            UserDefaults.standard.synchronize()
                        }
                    }
                    else if redirectAction == "startUpdateLatLongWithRideId"{
                        // navigate to RideInfoVC
                        manager.actionType = .startUpdateLatLongWithRideId
                        let dataAns:NSDictionary = (bodyData["dataAns"]! as! NSDictionary)
                        
                        if (dataAns.object(forKey: "rideId") != nil) {
                        manager.rideId = String(format:"%@",dataAns.object(forKey: "rideId") as! CVarArg)
                        
                        UserDefaults.standard.set(String(describe(manager.rideId)), forKey: ParamConstants.Defaults.rideId)
                        }
                        UserDefaults.standard.set(true, forKey: ParamConstants.Defaults.isRideAccepted)
                        UserDefaults.standard.set(true, forKey: ParamConstants.Defaults.isUnderRide)
                        UserDefaults.standard.synchronize()

                    }
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
