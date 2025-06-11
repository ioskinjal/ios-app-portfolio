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
        return UserDefaults().object(forKey: "UserDeviceToken") as? String ?? "111222333444555"
    }
    
    func setData(dic: [String:Any]) -> Bool {
        UserDefaults.standard.set(dic, forKey: "onBoarding")
        return UserDefaults.standard.synchronize()
    }
    
    func getData() -> [String:Any]? {
        if let user = UserDefaults.standard.value(forKey: "onBoarding") as? Dictionary<String,Any> {
            return user
        }
        return nil
    }
    
    func setDataFilter(dic: [String:Any]) -> Bool {
           UserDefaults.standard.set(dic, forKey: "filter")
           return UserDefaults.standard.synchronize()
       }
       
       func getDataFilter() -> [String:Any]? {
           if let user = UserDefaults.standard.value(forKey: "filter") as? Dictionary<String,Any> {
               return user
           }
           return nil
       }
    
    func setColorData(dic:ColorData) -> Bool {
        UserDefaults.standard.set(dic, forKey: "color")
        return UserDefaults.standard.synchronize()
    }
    
    func getColorData() -> [String:Any]?
    {
      if let user = UserDefaults.standard.value(forKey: "color") as? Dictionary<String,Any> {
        return user
        
        }
        return nil
    }
  
    func setDesignData(dic: [String:Any]) -> Bool {
          UserDefaults.standard.set(dic, forKey: "design")
          return UserDefaults.standard.synchronize()
      }
      
      func getDesignData() -> [String:Any]? {
          if let user = UserDefaults.standard.value(forKey: "design") as? Dictionary<String,Any> {
              return user
          }
          return nil
      }
    
    func setSizeData(dic: [String:Any]) -> Bool {
        UserDefaults.standard.set(dic, forKey: "design")
        return UserDefaults.standard.synchronize()
    }
    
    func getSizeData() -> [String:Any]? {
        if let user = UserDefaults.standard.value(forKey: "design") as? Dictionary<String,Any> {
            return user
        }
        return nil
    }
    
  func setDataMen(dic: [String:Any]) -> Bool {
    UserDefaults.standard.set(dic, forKey: string.landing)
         return UserDefaults.standard.synchronize()
     }
     
     func getDataMen() -> [String:Any]? {
        if let user = UserDefaults.standard.value(forKey: string.landing) as? Dictionary<String,Any> {
             return user
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
        
            //User is Not Loggedin case Handle
            userLoginStatus(status: false)
            M2_isUserLogin = false
            getQuoteId()
            let app = UIApplication.shared
            app.registerForRemoteNotifications()
        
       // }
    }
    
    func getQuoteId(){
        if !M2_isUserLogin && (UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") == "" ||  UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") == nil) {
            ApiManager.getQuoteID(params: [:], success: { (resp) in
                
                UserDefaults.standard.set(resp, forKey: "guest_carts__item_quote_id")
                UserDefaults.standard.synchronize()
            })  {
                // quote failure
                // failure()
            }
        }
        
    }
    
//    func removeStoredValues(key:String) -> Bool {
//        UserDefaults.standard.removeObject(forKey: key)
//        return UserDefaults.standard.synchronize()
//    }
    
}

