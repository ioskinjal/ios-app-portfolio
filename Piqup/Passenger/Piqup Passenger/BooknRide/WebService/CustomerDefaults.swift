//
//  CustomerDefaults.swift
//  BooknRide
//
//  Created by KASP on 15/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

let device_token = "userDeviceToken"
let fcm_token = "userFcmToken"


class CustomerDefaults: NSObject {

    class func saveDeviceToken(token:String) {
        
        UserDefaults.standard.set(token, forKey: device_token)
        UserDefaults.standard.synchronize()

        }
    
    class func getDeviceToken() -> String{
        
        return UserDefaults.standard.object(forKey: device_token) as? String ?? ""

    }
    
    class func saveFcmToken(token:String) {
        
        UserDefaults.standard.set(token, forKey: fcm_token)
        UserDefaults.standard.synchronize()
        
    }
    
    class func getFcmToken() -> String{
        
        return UserDefaults.standard.object(forKey: fcm_token) as? String ?? "test"
        
    }
    
}
