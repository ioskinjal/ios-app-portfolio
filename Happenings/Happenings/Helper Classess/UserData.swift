//
//  UserData.swift
//  Talabtech
//
//  Created by NCT 24 on 19/05/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class UserData {
    static let shared = UserData()
    
    func setDeviceToken(deviceToken:String) {
        UserDefaults().set(deviceToken, forKey: "UserDeviceToken")
        UserDefaults().synchronize()
    }
    
    var deviceToken: String {
        return UserDefaults().object(forKey: "UserDeviceToken") as? String ?? ""
    }
    
    func setUser(dic: [String:Any]) -> Bool {
        UserDefaults.standard.set(dic, forKey: "UserKey")
        return UserDefaults.standard.synchronize()
    }
    
    func getUser() -> User? {
        if let user = UserDefaults.standard.value(forKey: "UserKey") as? Dictionary<String,Any> {
            return User(dic: user)
        }
        return nil
    }
    
    func setUserLoginData(dic: [String:Any]) -> Bool {
        UserDefaults.standard.set(dic, forKey: "UserLoginData")
        return UserDefaults.standard.synchronize()
    }
    
    
    func getUserLoginData() -> UserLoginData? {
        if let user = UserDefaults.standard.value(forKey: "UserLoginData") as? Dictionary<String,Any> {
            return UserLoginData(dictionary: user)
        }
        return nil
    }
    
  
    
    func logoutUser(){
        //if let bundle =  Bundle.main.bundleIdentifier{
            //UserDefaults.standard.removePersistentDomain(forName: bundle)
            // RemoteNotifications
            UserDefaults.standard.removePersistentDomain(forName: "UserKey")
            UserDefaults.standard.removeObject(forKey: "UserKey")
            UserDefaults().synchronize()
            let app = UIApplication.shared
            app.registerForRemoteNotifications()
       // }
    }
    
//    func removeStoredValues(key:String) -> Bool {
//        UserDefaults.standard.removeObject(forKey: key)
//        return UserDefaults.standard.synchronize()
//    }
    
}

