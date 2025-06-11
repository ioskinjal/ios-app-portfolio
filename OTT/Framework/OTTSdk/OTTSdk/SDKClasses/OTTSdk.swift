//
//  YuppTVSDK.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class OTTSdk: NSObject {
    /// contains APIs like geo, config ...
    public class var appManager: AppManager {
        struct Singleton {
            static let obj = AppManager()
        }
        return Singleton.obj
    }
    
    // Contains APIs like login, signup, otp ...
    public class var userManager: UserManager {
        struct Singleton {
            static let obj = UserManager()
        }
        return Singleton.obj
    }
    
    // Contains APIs like channels, details , movies ...
    public class var mediaCatalogManager: MediaCatalogManager {
        struct Singleton {
            static let obj = MediaCatalogManager()
        }
        return Singleton.obj
    }
    
    
    // Contains stored variables
    public class var preferenceManager: PreferenceManager {
        struct Singleton {
            static let obj = PreferenceManager()
        }
        return Singleton.obj
    }
    
    // Contains APIs like InApp Details, InApp receipt submit
    public class var paymentsManager : PaymentsManager {
        struct Singleton {
            static let obj = PaymentsManager()
        }
        return Singleton.obj
    }
    
    // Contains APIs for static content like country list, Privacy Policy...
    public class var staticContentManager : StaticContentManager {
        struct Singleton {
            static let obj = StaticContentManager()
        }
        return Singleton.obj
    }
    
    // Contains API methods
    public class var api : API {
        struct Singleton {
            static let obj = API()
        }
        return Singleton.obj
    }
    
    //MARK: -
    

    /**
     This function intializes the frame work with provided settings
     
     - Usage :
     ````
     YuppTVSDK.initWithSettings(settings: ["isLive":false, "logType" : 2,"requestTimeout" : 60])
````
     - Parameters:
         - settings: optional *[String : Any]*  with predefined keys.
            
     
     * AppName : String
     - case reeldrama = "reeldrama"
     - case firstshows = "firstshows"
     - case aastha = "aastha"
     - Default : reeldrama
     
             * serviceType : Int
                - case live = 0
                - case UAT = 1
                - case beta = 2
                - case beta2 = 3
                - Default : live
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
    
    public init(settings : [String : Any]?, callback : @escaping (Bool, APIError?)-> Void) {
        super.init()
        //settings
        if let serviceType = settings?[APIConstants.Key.serviceType] as? PreferenceManager.SerViceType{
            PreferenceManager.serviceType = serviceType
        }
        
        // isLogEnabled
        if let logType = settings?[APIConstants.Key.logType] as? PreferenceManager.LogType{
            PreferenceManager.logType = logType
        }
        //AppName
        if let appName = settings?[APIConstants.Key.appName] as? PreferenceManager.AppName{
            PreferenceManager.appName = appName
        }
        // requestTimeout
        if let timeout = settings?[APIConstants.Key.requestTimeout] as? Double{
            PreferenceManager.requestTimeout = timeout
        }
        
        // isEncryptionEnabled
        if let encryptionEnabled = settings?[APIConstants.Key.isEncryptionEnabled] as? Bool{
            PreferenceManager.isEncryptionEnabled = encryptionEnabled
        }
        // clientAppVersion
        if let clientAppVersion = settings?[APIConstants.Key.clientAppVersion] as? String{
            PreferenceManager.clientAppVersion = clientAppVersion
        }
        PreferenceManager.isSdkInitialized = true
        OTTSdk.appManager.initiateSdk { (_isSupported,error) in
            if _isSupported == false{
                callback(_isSupported, error)
            }
            else{
                // Framework supported
                if PreferenceManager.sessionId.count == 0{
                    // get token, //config
                    
                    OTTSdk.appManager.getToken(onSuccess: {
                        OTTSdk.appManager.configuration(onSuccess: { (response) in
                            callback(true, nil)
                        }) { (error) in
                            callback(false, error)
                        }
                    }) { (error) in
                        callback(false, error)
                    }
                }
                else{
                    //config only
                    OTTSdk.appManager.configuration(onSuccess: { (response) in
                        callback(true, nil)
                    }) { (error) in
                        callback(false, error)
                    }
                }
            }
        }
    }
    
    public static func forceReset( isSupported : @escaping (Bool, APIError?)-> Void){
        
        OTTSdk.appManager.initiateSdk { (_isSupported,error) in
            if _isSupported == false{
                isSupported(_isSupported, error)
            }
            else{
                OTTSdk.appManager.getToken(onSuccess: {
                    ConfigResponse.StoredConfig.lastUpdated = nil
                    ConfigResponse.StoredConfig.response = nil
                    OTTSdk.appManager.configuration(onSuccess: { (response) in
                        isSupported(true, error)
                    }) { (error) in
                        isSupported(false, error)
                    }
                }) { (error) in
                    isSupported(false, error)
                }
            }
        }
    }
    
    /**
     To refresh urls
     
     - Parameters:
         - isSuccess: Bool
     - Returns: Void
     
     */
    public static func refresh( isSuccess : @escaping (Bool)-> Void){
        ConfigResponse.StoredConfig.lastUpdated = nil
        ConfigResponse.StoredConfig.response = nil
        OTTSdk.appManager.configuration(onSuccess: { (response) in
            isSuccess(true)
        }) { (error) in
            isSuccess(false)
        }
    }
    
    /**
     CheckForUpdate
     
     - Parameters:
     - onSuccess: LocationinfoResponse object
     - onFailure : APIError
     - Returns: Void
     */
    
    public static func checkForUpdate( onSuccess : @escaping (LocationinfoResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        LocationinfoResponse.StoredLocationinfo.lastUpdated = nil
        LocationinfoResponse.StoredLocationinfo.response = nil
        OTTSdk.appManager.updateLocation(onSuccess: { (response) in
            onSuccess(response)
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     This function to know whether this app should be blocked or not
     
      - Parameters:
         - isSupported: Bool
             * true : allow
             * false : block
     - Returns: Void
     
     */

    public static func isSupported(isSupported : @escaping (Bool)-> Void){
        if PreferenceManager.isSdkInitialized{
            isSupported(API.isSupported)
        }
        else{
            // Try again if not initialized or unsupported case
            OTTSdk.appManager.initiateSdk { (_isSupported,error) in
                isSupported(_isSupported)
            }
        }
    }
}
