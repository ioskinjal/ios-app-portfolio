//
//  UserData.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class UserData {
    static let shared = UserData()
    
    fileprivate struct UserKeys{
        //Below one line is apple default languages changes
        static let appleLanguages = "AppleLanguages"
        
        static let accessToken = "AccessToken"
        static let userDeviceToken = "UserDeviceToken"
        static let userInfo = "UserInfo"
        static let appLanguageID = "AppLanguageID"
        static let appLaunchFirstTime = "AppLaunchFirstTime"
        static let userAutoLoginData = "UserAutoLoginData"
    }
    
    var isAppLaunchFirstTime: Bool {
        return UserDefaults.standard.bool(forKey: UserKeys.appLaunchFirstTime) as Bool
    }
    
    func setAppLaunch(isLaunch:Bool) {
        UserDefaults.standard.set(isLaunch, forKey: UserKeys.appLaunchFirstTime)
        UserDefaults.standard.synchronize()
    }
    
    var deviceToken: String {
        return UserDefaults.standard.object(forKey: UserKeys.userDeviceToken) as? String ?? "111222333444555"
    }
    
    func setDeviceToken(deviceTkn:String) {
        UserDefaults.standard.set(deviceTkn, forKey: UserKeys.userDeviceToken)
        UserDefaults.standard.synchronize()
    }
    
    var accessToken: String {
        return UserDefaults.standard.object(forKey: UserKeys.accessToken) as? String ?? "111222333"
    }
    
    func setAccessToken(accessToken:String) {
        UserDefaults.standard.set(accessToken, forKey: UserKeys.accessToken)
        UserDefaults.standard.synchronize()
    }
    
    @discardableResult
    func setUser(dic: [String:Any]) -> Bool {
        UserDefaults.standard.set(dic, forKey: UserKeys.userInfo)
        return UserDefaults.standard.synchronize()
    }
    
    func getUser() -> User? {
        if let user = UserDefaults.standard.value(forKey: UserKeys.userInfo) as? Dictionary<String,Any> {
            return User(dictionary: user)
        }
        return nil
    }
   
    var languageID: String{
        return UserDefaults.standard.object(forKey: UserKeys.appLanguageID) as? String ?? ""
    }
    
    func setLanguageID(languageID:String) {
        UserDefaults.standard.set(languageID, forKey: UserKeys.appLanguageID)
        UserDefaults.standard.synchronize()
        
        //Apple default languages change as per that apple manage own LTR ot RTL apperence
        //UserDefaults.standard.set(["en"], forKey: UserKeys.appLanguageID) // ["ar"]
//        if !languageID.isBlank{
//            UserDefaults.standard.set([languageID], forKey: UserKeys.appleLanguages)
//        }
        
    }
    
    func logoutUser(isAllDelete:Bool = false) {
        UserDefaults.standard.set(nil, forKey: UserKeys.userInfo)
        UserDefaults.standard.set(nil, forKey: UserKeys.accessToken)
//        if isAllDelete{
//            UserDefaults.standard.set(nil, forKey: UserKeys.appLaunchFirstTime)
//            UserDefaults.standard.set(nil, forKey: UserKeys.appLanguageID)
//        }
        //UserDefaults.standard.set(nil, forKey: UserKeys.userAutoLoginData)
    }
    
    func setAutoLoginData(dic: [String:Any]) -> Bool {
        UserDefaults.standard.set(dic, forKey: UserKeys.userAutoLoginData)
        return UserDefaults.standard.synchronize()
    }
    
    func getAutoLoginData() -> UserAutoLoginData? {
        if let user = UserDefaults.standard.value(forKey: UserKeys.userAutoLoginData) as? Dictionary<String,Any> {
            return UserAutoLoginData(dictionary: user)
        }
        return nil
    }
    
}

