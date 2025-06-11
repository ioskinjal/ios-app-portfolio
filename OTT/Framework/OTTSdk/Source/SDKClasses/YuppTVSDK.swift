//
//  YuppTVSDK.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class YuppTVSDK: NSObject {
    
    /**
     This function intializes the frame work with provided settings
     
     - Usage :
     ````
     YuppTVSDK.initWithSettings(settings: ["isLive":false, "logType" : 2,"requestTimeout" : 60])
````
     - Parameters:
         - settings: optional *[String : Any]*  with predefined keys.
     
             * isLive : Bool 
               - Default : true
               - Ex: isLive : true
             * logType : Int
     
                 * 0 : none (Default)
                 * 1: requestsOnly
                 * 2: requestAndHeaders
                 * 3: complete

                 - Ex:  logType : 2
             * requestTimeout : Double  //in seconds
                - Default : Live
                - Ex:  requestTimeout : 60
             * isEncryptionEnabled : Bool
                 - Default : true
                 - Ex:  isEncryptionEnabled : false
     - Returns: Void
     
     */
    
    public static func initWithSettings(settings : [String : Any]?) {
        // isLive
        if let live = settings?[APIConstants.Key.isLive] as? Bool{
            PreferenceManager.isLive = live
        }
        
        // isLogEnabled
        if let logType = settings?[APIConstants.Key.logType] as? Int{
            if let logT = PreferenceManager.LogType(rawValue: logType){
                PreferenceManager.logType = logT
            }
        }
        
        // requestTimeout
        if let timeout = settings?[APIConstants.Key.requestTimeout] as? Double{
            PreferenceManager.requestTimeout = timeout
        }
        
        // isEncryptionEnabled
        if let encryptionEnabled = settings?[APIConstants.Key.isEncryptionEnabled] as? Bool{
            PreferenceManager.isEncryptionEnabled = encryptionEnabled
        }
    }
    
    public class var userManager: UserManager {
        struct Singleton {
            static let obj = UserManager()
        }
        return Singleton.obj
    }
    
    public class var mediaCatalogManager: MediaCatalogManager {
        struct Singleton {
            static let obj = MediaCatalogManager()
        }
        return Singleton.obj
    }
    
    public class var statusManager: StatusManager {
        struct Singleton {
            static let obj = StatusManager()
        }
        return Singleton.obj
    }
    
    public class var preferenceManager: PreferenceManager {
        struct Singleton {
            static let obj = PreferenceManager()
        }
        return Singleton.obj
    }
    
    public class var paymentsManager : PaymentsManager {
        struct Singleton {
            static let obj = PaymentsManager()
        }
        return Singleton.obj
    }
    
    public class var staticContentManager : StaticContentManager {
        struct Singleton {
            static let obj = StaticContentManager()
        }
        return Singleton.obj
    }
    
}
