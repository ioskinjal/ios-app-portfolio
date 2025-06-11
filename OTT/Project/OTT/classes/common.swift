//
//  common.swift
//  sampleColView
//
//  Created by Mohan Agadkar on 05/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
        }
    func toMillisString() -> String! {
        return String(self.timeIntervalSince1970 * 1000)
        }
    }

struct productType {
    static let iPhone  = UIDevice.current.userInterfaceIdiom == .phone
    static let iPad  = UIDevice.current.userInterfaceIdiom == .pad
    @available(iOS 9.0, *)
    static let AppleTV  = UIDevice.current.userInterfaceIdiom == .tv
}

struct appContants {
    #warning("serviceType should be PreferenceManager.SerViceType.live")
    static let serviceType = PreferenceManager.SerViceType.live
    
    #warning("logType commoshould be PreferenceManager.LogType.none")
    static let logType = PreferenceManager.LogType.none
    
    #warning("check appName before submitting")
    static let appName = PreferenceManager.AppName.aastha

    static let isChromeCastEnabled:Bool = false
    
    static var isEnabledAnalytics:Bool = true
    static var isEnabledLocalytics:Bool = false
    static let ViewAnalyticsLog:Bool = false
    static let key = "39353438373233363533353232313537"
    static let encIV = "9EHYACllZ_tnn2Vw"
    static let pubNubPublishKey = "pub-c-b200d2b8-e786-4f61-84e9-e0e0d2e61b2f"
    static let pubNubSubscribeKey = "sub-c-dc9bef7e-c346-11e5-8a35-0619f8945a4f"

    static var lastWatchedContentPaths : [String]? {
        set {
            if newValue == nil{
                UserDefaults.standard.removeObject(forKey: "lastWatchedContentResponse")
                UserDefaults.standard.synchronize()
                return;
            }
            var paths = newValue!
            if paths.count > 3{
                paths.removeFirst()
            }
            
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: paths), forKey: "lastWatchedContentResponse")
            UserDefaults.standard.synchronize()
        }
        get {
            if let data = UserDefaults.standard.object(forKey: "lastWatchedContentResponse") as? Data{
                if let response = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String]{
                    return response;
                }
            }
            return nil
        }
    }
}

class currentOrientation {
    var portrait  = UIDevice.current.orientation.isPortrait == true
    var landscape  = UIDevice.current.orientation.isLandscape == true
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  productType.iPhone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = productType.iPhone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = productType.iPhone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = productType.iPhone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD_PRO = productType.iPad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_IPHONE_X = productType.iPhone && ScreenSize.SCREEN_MAX_LENGTH >= 812.0
}
func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(1.0))
}
func RGBa(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a))
}
func printYLog(_ args: Any...){
    if appContants.serviceType == PreferenceManager.SerViceType.live {
        #if DEBUG
        CLSNSLogv("%@", getVaList([args]))
        #else
        CLSLogv("%@", getVaList([args]))
        #endif
    } else {
        CLSNSLogv("%@", getVaList([args]))
    }
}

func saveUserConsentOnAgeAndDob() {
    let userDefaults = UserDefaults.standard
    userDefaults.set(true, forKey: "ageAndDob")
    userDefaults.synchronize()
}
func getUserConsentOnAgeAndDob() -> Bool {
    let userDefaults = UserDefaults.standard
    let value = userDefaults.bool(forKey: "ageAndDob")
    return value
}
func deleteUserConsentOnAgeAndDob() {
    let userDefaults = UserDefaults.standard
    userDefaults.removeObject(forKey: "ageAndDob")
    userDefaults.removeObject(forKey: "SHOW_PIN_FOR_DARK_POPUP_DURATION")
    userDefaults.synchronize()
}
