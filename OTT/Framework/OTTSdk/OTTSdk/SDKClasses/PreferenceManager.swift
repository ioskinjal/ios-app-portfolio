//
//  PreferenceManager.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PreferenceManager: NSObject {
    
    public var selectedLanguages : String {
        set{
            UserDefaults.standard.set(newValue, forKey: APIConstants.Key.selectedLanguages)
        }
        get{
            guard let _selectedLngCode = UserDefaults.standard.value(forKey: APIConstants.Key.selectedLanguages) as? String else{
                return ""
            }
            return _selectedLngCode
        }
    }
    internal var countryCode  : String{
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
    
    internal static var isSdkInitialized = false
    
    public enum LogType : Int{
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
            if newValue.count > 0{
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
    
    public enum SerViceType : Int{
        case live = 0
        case UAT = 1
        case beta = 2
        case beta2 = 3
    }
    public enum AppName : String {
        
        case reeldrama = "reeldrama"
        case firstshows = "firstshows"
        case aastha = "aastha"
        case tsat = "tsat"
        case gotv = "gotv"
        case yvs = "yvs"
        case supposetv = "supposetv"
        case mobitel = "mobitel"
        case pbns = "pbns"
        case airtelSL = "airtelSL"
        case gac = "gac"
    }
    internal static var serviceType : SerViceType = SerViceType.live
    internal static var appName : AppName = AppName.reeldrama
    internal static var logType = LogType.none
    internal static var requestTimeout : Double = 60 // in Seconds
    internal static var isEncryptionEnabled = true
    internal static var encIV : String {
        get {
            if appName == .reeldrama {
                if deviceType == "6" {
                    return "b70f61dbe46d139f"
                }else if deviceType == "7" {
                    return "756d63a02db66f44"
                }
                return "756d63a02db66f44"
            }else if appName == .firstshows {
                if deviceType == "6" {
                    return "eca859faa5422657"
                }else if deviceType == "7" {
                    return "e7e8df38d117e599"
                }
                return "e7e8df38d117e599"
            }
            return "82c0ef703ebca700"
        }
    }
    internal static var encKey : String {
        get {
            var sha = "d8055936-7597-4855-ab15-e5abe64a56b8".sha256()
            if appName == .reeldrama {
                if deviceType == "6" {
                    sha = "f8bc78cf-84bd-4974-b8f7-8c2c04b42e35".sha256()
                }else if deviceType == "7" {
                    sha = "ec6a661d-b3e5-40a0-bb8a-07b480b0f84a".sha256()
                }else {
                    sha = "ec6a661d-b3e5-40a0-bb8a-07b480b0f84a".sha256()
                }
            }else if appName == .firstshows {
                if deviceType == "6" {
                    sha = "4e833133-d25e-44ea-8d58-5c4d9569d061".sha256()
                }else if deviceType == "7" {
                    sha = "f851f3e8-4ad2-4a07-ada9-526503175fd3".sha256()
                }else {
                    sha = "f851f3e8-4ad2-4a07-ada9-526503175fd3".sha256()
                }
            }
            return String(sha.prefix(32))
        }
    }
//    internal static let encIV = "82c0ef703ebca700" //(deviceType == "55") ? :
//    internal static var encKey : String{
//        let sha = "d8055936-7597-4855-ab15-e5abe64a56b8".sha256()
//        return String(sha.prefix(32))
//    }
    public var featuresResponse : FeatureResponse?
    internal var product = ""
    public var tenantCode = ""
    internal let client = "ios"
    public static var clientAppVersion:String = ""
    
    public static var deviceType : String{
        get{
            if UIDevice.current.userInterfaceIdiom == .pad{
                return "6"
            }
            else if UIDevice.current.userInterfaceIdiom == .phone{
                return "7"
            }
            if UIDevice.current.userInterfaceIdiom == .tv{
                return "55"
            }
            else{
                return "7"
            }
        }
    }
    internal static var deviceSubType : String{
        get{
            return ("\(PreferenceManager.modelIdentifier())-\(UIDevice.current.systemVersion)")
        }
    }
    static func modelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
        
    }
    public static var sessionId : String{
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
    
    public var selectedDisplayLanguage : String?{
        set{
            UserDefaults.standard.set(newValue, forKey: APIConstants.Key.displayLanguageKey)
        }
        get{
            return UserDefaults.standard.value(forKey: APIConstants.Key.displayLanguageKey) as? String
        }
    }
    
    public static var boxId : String{
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

    public var userPrefferedLanguages : NSMutableArray?{
        set{
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: newValue!)
            UserDefaults.standard.set(encodedData, forKey: APIConstants.Key.userPreferredLanguages)
        }
        get{
            guard let decoded  = UserDefaults.standard.object(forKey:  APIConstants.Key.userPreferredLanguages) as? Data else{
                return nil
            }
            return NSKeyedUnarchiver.unarchiveObject(with: decoded) as? NSMutableArray
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
