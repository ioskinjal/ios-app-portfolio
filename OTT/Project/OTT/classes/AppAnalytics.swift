//
//  Analytics.swift
//  OTT
//
//  Created by Muzaffar on 13/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
import Crashlytics

class AppAnalytics: NSObject {
    
    static var navigatingFrom = "-1"
    
    public class var shared: AppAnalytics {
        struct Singleton {
            static let obj = AppAnalytics()
        }
        return Singleton.obj
    }
    
    func updateUser(){
        OTTCrashlytics.shared.updateUser()
    }
}

class OTTCrashlytics: NSObject {
    // Contains APIs like login, signup, otp ...
   
    public class var shared: OTTCrashlytics {
        struct Singleton {
            static let obj = OTTCrashlytics()
        }
        return Singleton.obj
    }
    

    func updateUser(){
        /*if let userId = OTTSdk.preferenceManager.user?.userId{
            Crashlytics.sharedInstance().setUserName(OTTSdk.preferenceManager.user?.name)
            Crashlytics.sharedInstance().setUserEmail(OTTSdk.preferenceManager.user?.email)
            
            Crashlytics.sharedInstance().setUserIdentifier(String(userId))
            
            let user = FreshchatUser.sharedInstance();
            user.phoneNumber = OTTSdk.preferenceManager.user?.phoneNumber
            Freshchat.sharedInstance().setUser(user)
        }
        else{
            Crashlytics.sharedInstance().setUserIdentifier(nil)
            Freshchat.sharedInstance().resetUser(completion: { () in
                
            })
            
        }*/
    }
}
