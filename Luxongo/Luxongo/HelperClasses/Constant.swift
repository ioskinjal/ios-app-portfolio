//
//  Constant.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let editProfile = Notification.Name("editProfile")
    static let eventModify = Notification.Name("eventModify")
}

extension DateFormatter{
    static let appDateTimeFormat = "yyyy-MM-dd HH:mm:ss" //"dd-MM-yyyy"//"MM-dd-yyyy" //"yyyy-MM-dd HH:mm" //"yyyy-MM-dd"
    static let appDateFormat = "yyyy-MM-dd"
    static let appDateDisplayFormate = "dd MMM, yyyy | HH:mm"
}

struct StoryBoard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let home = UIStoryboard(name: "Home", bundle: nil)
    static let accountSetting = UIStoryboard(name: "AccountSetting", bundle: nil)
    static let profile = UIStoryboard(name: "Profile", bundle: nil)
    static let purchaseTicket = UIStoryboard(name: "PurchaseTicket", bundle: nil)
    static let paymentHistory = UIStoryboard(name: "PaymentHistory", bundle: nil)
    static let manageEvents = UIStoryboard(name: "ManageEvents", bundle: nil)
    static let manageContacts = UIStoryboard(name: "ManageContacts", bundle: nil)
    static let createEvent = UIStoryboard(name: "CreateEvent", bundle: nil)
    static let bookingEvent = UIStoryboard(name: "BookingEvent", bundle: nil)
    static let eventDetails = UIStoryboard(name: "EventDetails", bundle: nil)
    static let imageCropper = UIStoryboard(name: "ImageCropper", bundle: nil)
}

struct ScreenSize { // Answer to OP's question
    
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    
}

struct DeviceType { //Use this to check what is the device kind you're working with
    
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5_OR_5SE   = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_7PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X_OR_Xs    = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_Xr_OR_Xmax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    
}


struct iOSVersion { //Get current device's iOS version
    
    static let SYS_VERSION_FLOAT  = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7               = (iOSVersion.SYS_VERSION_FLOAT >= 7.0 && iOSVersion.SYS_VERSION_FLOAT < 8.0)
    static let iOS8               = (iOSVersion.SYS_VERSION_FLOAT >= 8.0 && iOSVersion.SYS_VERSION_FLOAT < 9.0)
    static let iOS9               = (iOSVersion.SYS_VERSION_FLOAT >= 9.0 && iOSVersion.SYS_VERSION_FLOAT < 10.0)
    static let iOS10              = (iOSVersion.SYS_VERSION_FLOAT >= 10.0 && iOSVersion.SYS_VERSION_FLOAT < 11.0)
    static let iOS11              = (iOSVersion.SYS_VERSION_FLOAT >= 11.0 && iOSVersion.SYS_VERSION_FLOAT < 12.0)
    static let iOS12              = (iOSVersion.SYS_VERSION_FLOAT >= 12.0 && iOSVersion.SYS_VERSION_FLOAT < 13.0)
    
}


struct Response{
    
    static func fatchDataAsDictionary(res: dictionary, valueOf key: keys) -> [String:Any] {
        if res[key.rawValue] as? [String:Any] != nil{
            print("Dictionary as a response")
            return res[key.rawValue] as! [String:Any]
        }
        else{
            if res[key.rawValue] as? [Any] != nil{
                print("Response is different: Array as a response")
                return [:]
            }
            else if res[key.rawValue] as? String != nil{
                print("Response is different: String as a response")
                return [:]
            }else{
                print("Response is different: Response type not a Dictionary nore Array or String")
                return [:]
            }
        }
    }
    
    static func fatchDataAsArray(res: dictionary, valueOf key: keys) -> [Any] {
        if res[key.rawValue] as? [Any] != nil{
            print("Array as a response")
            return res[key.rawValue] as! [Any]
        }
        else{
            if res[key.rawValue] as? [String:Any] != nil{
                print("Response is different: Dictionary as a response")
                return []
            }
            else if res[key.rawValue] as? String != nil{
                print("Response is different: String as a response")
                return []
            }else{
                print("Response is different: Response type not a Dictionary nore Array or String")
                return []
            }
        }
    }
    
    static func fatchDataAsString(res: dictionary, valueOf key: keys) -> String {
        if res[key.rawValue] as? String != nil{
            print("String as a response")
            return res[key.rawValue] as! String
        }
        else{
            if res[key.rawValue] as? [Any] != nil{
                print("Response is different: Array as a response")
                return ""
            }
            else if res[key.rawValue] as? [String:Any] != nil{
                print("Response is different: Dictionary as a response")
                return ""
            }else{
                print("Response is different: Response type not a Dictionary nore Array or String")
                return ""
            }
        }
    }
    
    static func fatchData(res: dictionary, valueOf key: keys) -> (dic: [String:Any], ary: [Any], str: String){
        if res[key.rawValue] as? [String:Any] != nil{
            print("Dictionary as a response")
            return (dic: res[key.rawValue] as! [String:Any], ary: [], str: "")
        }
        else if res[key.rawValue] as? [Any] != nil{
            print("Array as a response")
            return (dic: [:], ary: res[key.rawValue] as! [Any], str: "")
        }
        else if res[key.rawValue] as? String != nil{
            print("String as a response")
            return (dic: [:], ary: [], str: res[key.rawValue] as! String)
        }else{
            print("Response type not a Dictionary nore Array or String")
            return (dic: [:], ary:[], str: "")
        }
    }
    
    
}


func isCheckEmptyText(textField: UITextField..., errString:[String]) -> Bool {
    var ErrorMsg = ""
    for (i,tf) in textField.enumerated(){
        if (tf.text ?? "").isBlank{
            ErrorMsg = errString[i]
            break
        }
    }
    if !ErrorMsg.isEmpty {
        UIApplication.alert(title: "Error".localized, message: ErrorMsg.localized, style: .destructive)
        return false
    }
    else {
        return true
    }
}


//    func isValidated() -> Bool {
//        if isCheckEmptyText(textField: tfEmail,tfPassword, errString: ["Please enter an email", "Please enter Password"]){
//            var ErrorMsg = ""
//            if !tfEmail.text!.isValidEmailId {
//                ErrorMsg = "Please enter valid email id"
//            }
//            if ErrorMsg != "" {
//                UIApplication.alert(title: "Error".localized, message: ErrorMsg.localized, style: .destructive)
//                return false
//            }
//            else {
//                return true
//            }
//        }
//        else {
//            return false
//        }
//    }

