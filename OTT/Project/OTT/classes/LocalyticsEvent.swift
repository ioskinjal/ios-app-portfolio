//
//  LocalyticsEvent.swift
//  OTT
//
//  Created by Chandra Sekhar on 31/10/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
//import Localytics
import Firebase
import Firebase
import OTTSdk

class LocalyticsEvent: NSObject {
    
    static func tagScreen(_ screenName:String) {
        print("Screen name : \(screenName)")
//        if AppDelegate.getDelegate().supportLocalytics {
//            Localytics.tagScreen(screenName)
//        }
        if AppDelegate.getDelegate().supportFireBase {
            if let topVC = UIApplication.topVC(){
                Analytics.setScreenName(screenName, screenClass: topVC.className())
            }
            else{
                print("Screen name : \(screenName) : UIApplication.topVC is nil -----------------------------")
            }
        }
    }

    static func tagEvent(_ eventName:String) {
        print("Event name : \(eventName)")
//        if AppDelegate.getDelegate().supportLocalytics {
//            Localytics.tagEvent(eventName)
//        }
        if AppDelegate.getDelegate().supportFireBase {
            let tempEventName = LocalyticsEvent.replaceSpaceWithUnderscoreFor(eventName)
            Analytics.logEvent(tempEventName, parameters: nil)
        }
        if AppDelegate.getDelegate().supportCleverTap{
            let tempAttributes = self.getCommonEventAttributes()
            CleverTap.sharedInstance()?.recordEvent(eventName, withProps: tempAttributes)
        }
    }
    
    static func tagEventWithAttributes(_ eventName:String, _ attributes:[String:String]) {
        print("Event name : \(eventName) and Attributes : \(attributes)")
        var tempAttributes = self.getCommonEventAttributes()
        for (key,value) in attributes {
            if value.isEmpty{
                tempAttributes[key] = "Not Available"
            }
            else{
                tempAttributes[key] = value
            }
        }
//        if AppDelegate.getDelegate().supportLocalytics {
//            Localytics.tagEvent(eventName, attributes: tempAttributes)
//        }
        if AppDelegate.getDelegate().supportFireBase {
            print("Event name : \(eventName) and Attributes : \(tempAttributes)")
//            let tempEventName = LocalyticsEvent.replaceSpaceWithUnderscoreFor(eventName)
//            Analytics.logEvent(tempEventName, parameters: tempAttributes)
        }
        if AppDelegate.getDelegate().supportCleverTap{
            CleverTap.sharedInstance()?.recordEvent(eventName, withProps: tempAttributes)
        }
       
        
        
        
        /**
         * Data types:
         * The value of a property can be of type NSDate, a Number, a String, or a Bool.
         *
         * NSDate object:
         * When a property value is of type NSDate, the date and time are both recorded to the second.
         * This can be later used for targeting scenarios.
         * For e.g. if you are recording the time of the flight as an event property,
         * you can send a message to the user just before their flight takes off.
         */
    }
    
    static func replaceSpaceWithUnderscoreFor(_ eventName:String) -> String {
        return eventName.replacingOccurrences(of: " ", with: "_")
    }
    
    static func getCommonEventAttributes() -> [String:String] {
        var commonAttribute = [String:String]()
        commonAttribute["Country"] = AppDelegate.getDelegate().country
        commonAttribute["City"] = AppDelegate.getDelegate().city
        commonAttribute["User_ID"] = OTTSdk.preferenceManager.user != nil ? "\(OTTSdk.preferenceManager.user!.userId)" : "Not Available"
        commonAttribute["Source_Menu"] = AppDelegate.getDelegate().sourceScreen
        commonAttribute["TimeStamp"] = self.getHourType()
        commonAttribute["Platform"] = "iOS"

        return commonAttribute
    }
    
    static func pushProfileOnLogin() {
        if AppDelegate.getDelegate().supportCleverTap {
            if let userProfile = OTTSdk.preferenceManager.user {
                let profile: Dictionary<String, Any> = [
                    "Name": userProfile.name,       // String
                    "Identity": userProfile.userId,         // String or number
                    "Email": userProfile.email,    // Email address of the user
                    "Phone": "+\(userProfile.phoneNumber)",      // Phone (with the country code, starting with +)
                ]
                CleverTap.sharedInstance()?.onUserLogin(profile)
            }
        }
    }
    
    static func getHourType() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<4 : return "Mid Night"
        case 4..<8 : return "Early Morning"
        case 8..<12 : return "Morning"
        case 12..<16 : return "Afternoon"
        case 16..<20 : return "Evening"
        case 20..<24 : return "Night"
        default: return ""
        }
    }
}
