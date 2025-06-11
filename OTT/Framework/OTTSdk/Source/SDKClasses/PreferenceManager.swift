//
//  PreferenceManager.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PreferenceManager: NSObject {
    
    public var selectedLanguages : String{
        get{
            guard let lang = user?.preferences.lang else{
                return localLanguages
            }
            return lang
        }
    }
    
    public var countryCode  : String{
        set{
                UserDefaults.standard.set(newValue, forKey: APIConstants.Key.countryCodeKey)
        }
        get{
            guard let _countryCode = UserDefaults.standard.value(forKey: APIConstants.Key.countryCodeKey) as? String else{
                return ""
            }
            return _countryCode
        }
    }
    
    internal enum LogType : Int{
        case none = 0
        case requestsOnly = 1
        case requestAndHeaders = 2
        case complete = 3
    }
    /**
     These languages will be used only when user is not logged-in.
     When user logged-in localLanguages will not be used. user?.preferences.lang will be used instead.
     - localLanguages : comma separated Language codes.
     */
    public var localLanguages : String{
        set{
            if newValue.characters.count > 0{
                UserDefaults.standard.set(newValue, forKey: APIConstants.Key.localLanguages)
            }
            else{
                UserDefaults.standard.removeObject(forKey: APIConstants.Key.localLanguages)
            }
        }
        get{
            guard let localLanguages = UserDefaults.standard.value(forKey: APIConstants.Key.localLanguages) as? String else{
                return "all"
            }
            return localLanguages
        }
    }
    internal static var isLive = true
    internal static var logType = LogType.none
    internal static var requestTimeout : Double = 60 // in Seconds
    internal static var isEncryptionEnabled = true
    internal static let encIV = (deviceType == "55") ? "be9Y3bnQar-0e0Na" : "9EHYACllZ_tnn2Vw"
    internal static var deviceType : String{
        get{
            if #available(iOS 9.0, *) {
                if UIDevice.current.userInterfaceIdiom == .tv{
                    return "55"
                }
                else{
                    return "7"
                }
            } else {
                return "7"
            }
        }
    }
    
    internal static var sessionId : String{
        set{
            UserDefaults.standard.set(newValue, forKey: APIConstants.Key.sessionKey)
        }
        get{
            if let session = UserDefaults.standard.value(forKey: APIConstants.Key.sessionKey) as? String{
               return session
            }
            else{
                return ""
            }
        }
    }
    
    public var boxId : String{
        get{
            //#warning comment onDeleteKeychain
            // appDelegateDefault.onDeleteKeychain(Constants.Key.boxId)
            
            var boxId = Utility.sharedInstance.onGetKeychain(keyName: APIConstants.Key.boxId) as String
            if boxId != "" {
                return boxId
            }
            else {
                boxId = UIDevice.current.identifierForVendor!.uuidString
                Utility.sharedInstance.onSaveKeychain(keyName: APIConstants.Key.boxId, keyValue: boxId)
                return boxId
            }
        }
    }
    
    public var user : User?{
        set{
            if newValue != nil{
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                UserDefaults.standard.set(encodedData, forKey: APIConstants.Key.user)
            }
            else{
                UserDefaults.standard.removeObject(forKey: APIConstants.Key.user)
            }
        }
        get{
            guard let decoded  = UserDefaults.standard.object(forKey:  APIConstants.Key.user) as? Data else{
                return nil
            }
            return NSKeyedUnarchiver.unarchiveObject(with: decoded) as? User
        }
    }
    /*
    internal func updateUserPreferences(preference : Preference?) {
        if preference == nil {
            YuppTVSDK.userManager.userInfo(onSuccess: { (user) in
                // preferences will be saved in the method call.
            }, onFailure: { (error) in
            })
        }
        else{
            self.user?.preferences = preference!
        }
    }
    */
    internal override init() {
        super.init()
    }
    
}
