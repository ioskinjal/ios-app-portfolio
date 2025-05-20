//
//  UserData.swift
//  BistroStays
//
//  Created by NCT109 on 05/09/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import Foundation

class UserData {
    static let shared = UserData()
    
    func setDeviceToken(deviceToken:String) {
        UserDefaults().set(deviceToken, forKey: "UserDeviceToken")
        UserDefaults().synchronize()
    }
    func setProfileImage(imageUrl:String) {
        if var user = UserDefaults.standard.value(forKey: "UserKey") as? Dictionary<String,Any> {
            user["user_profile_image"] = imageUrl
            _ = setUser(dic: user)
        }
    }
    var getLanguage: String {
        return UserDefaults().object(forKey: "IS_Lang") as? String ?? "1"
    }
    func setLanguage(language:String) {
        UserDefaults().set(language, forKey: "IS_Lang")
        UserDefaults().synchronize()
    }
    func setGuideValue(language:String) {
        UserDefaults().set(language, forKey: "IS_Guide")
        UserDefaults().synchronize()
    }
    var getGuideValue: String {
        return UserDefaults().object(forKey: "IS_Guide") as? String ?? ""
    }
    var deviceToken: String {
        return UserDefaults().object(forKey: "UserDeviceToken") as? String ?? "123456"
    }
    
    func setUser(dic: [String:Any]) -> Bool {
        UserDefaults.standard.set(dic, forKey: "UserKey")
        return UserDefaults.standard.synchronize()
    }
    
    func getUser() -> LoginData? {
        if let user = UserDefaults.standard.value(forKey: "UserKey") as? Dictionary<String,Any> {
            return LoginData(dic: user)
        }
        return nil
    }
    
    func logoutUser(){
        if let bundle =  Bundle.main.bundleIdentifier{
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            // RemoteNotifications
            let app = UIApplication.shared
            app.registerForRemoteNotifications()
        }
    }
    
    func removeStoredValues(key:String) -> Bool {
        UserDefaults.standard.removeObject(forKey: key)
        return UserDefaults.standard.synchronize()
    }
}
