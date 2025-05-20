//
//  Constants.swift
//  ConnectIn
//
//  Created by NCrypted on 19/04/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//
import UIKit
//import SwiftGifOrigin
//MARK:- propaties



enum fontOfLosinger:String
{
    case MuliBold
    case MuliRegular
    var font:String
    {
        switch self
        {
        case .MuliBold: return "Muli-Bold"
        case .MuliRegular: return "MuliRegular"
        }
    }
}


//MARK:- stroyboryboars enum
enum  AppStoryboard:String
{
    case Main,Message,Products,Bids,MyProfile,Parties,Bundle,Order
    var instance : UIStoryboard
    {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    func viewController <T:UIViewController>(viewControllerClass : T.Type) -> T
    {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}


//MARK:- color Enume
enum colors
{
    case DarkBlue,Blue,LightGray,Gray,DarkGray
    
    var color:UIColor
    {
        switch self
        {
        case .DarkBlue : return UIColor(r: 26, g: 68, b: 129)
        case .Blue : return UIColor(r: 28, g: 82, b: 160)
        case .LightGray : return UIColor(r: 210, g: 210, b: 210)
        case .Gray : return UIColor(r: 146, g: 146, b: 146)
        case .DarkGray : return UIColor(r: 62, g: 62, b: 62)
        }
    }
}

//MARK:- error enum
enum uploadError: Error
{
    case incompleteForm
    case invalidEmail
    case passwordNotMatch
    case unCheakTermsAndCondition
    case unCkeakPrivacyAndPolicy
}

public enum Result<T>
{
    case success(T)
    case failure(Error)
}
//MARK:- API respones main key
struct OtherThirdPartyKeys
{
    
}
struct StoryBoard {
    static let Products = UIStoryboard(name: "Products", bundle: nil)
    static let imageCropper  = UIStoryboard(name: "ImageCropper", bundle: nil)
}
enum keys:String
{
    case status = "status"
    case message = "message"
    case data = "data"
    case bidlist = "bidlist"
    case products = "products"
    case followerList = "followerList"
    
    
}


//MARK:- API
enum baseAPI:String
{
    case local = "http://losinger.ncryptedprojects.com/ws-"
    case main = ""
}

enum endPoints:String
{
    case login = "login"
    case account_setting = "account_setting"
    case notification = "notification"
    case contactUs = "home"
    case profile = "profile"
    case editProfile = "edit-profile"
    case editCar = "edit-car"
    case message = "message"
    case mybooking = "my-booking"
    case myreservation = "my-reservation"
    case search = "search"
    case offerride = "offer-ride"
    case ridedetail = "ride-detail"
    case popularRides = "popular-rides"
    case reviews = "reviews"
    case content = "content"
}
enum actions:String
{
    case login = "login"
    case logout = "logout"
    case forgotPassword = "forgotPassword"
    case changePassword = "changePassword"
    case getNotificationData = "getNotificationData"
    case setNotificationData = "setNotificationData"
    case getNotifications = "getNotifications"
    case contactUs = "contactUs"
    case getDetail = "getDetail"
    case editProfile = "editProfile"
    case getCarBrandColor = "getCarBrandColor"
    case editCarDetails = "editCarDetails"
    case socialVerify = "socialVerify"
    case getUserList = "getUserList"
    case deleteMessage = "deleteMessage"
    case getConversation = "getConversation"
    case getSearchRide = "getSearchRide"
    case getAdminPopularRides = "getAdminPopularRides"
    case getRideSeatAvailability = "getRideSeatAvailability"
    case createOfferRide = "createOfferRide"
    case getDriverRideDetail = "getDriverRideDetail"
    case getCustomerRideDetail = "getCustomerRideDetail"
    case pointStatusChange = "pointStatusChange"
    case acceptRejectRequest = "acceptRejectRequest"
    case cancelRide = "cancelRide"
    case rideBooking = "rideBooking"
    case getLanguageList = "getLanguageList"
    case postReview = "postReview"
    case getProposedRides = "getProposedRides"
    case getUserAllReview = "getUserAllReview"
    case postFeedback = "postFeedback"
    case getFooterLinkContent = "getFooterLinkContent"
    case sendMessage = "sendMessage"
    case requestBookNow = "requestBookNow"
    case reportUser = "reportUser"
}

//MARK:- Email Notification Setting Enum
enum emailNotificationList:String
{
    case request_received = "arrNotification[request_received]"
    case request_accepted = "arrNotification[request_accepted]"
    case request_rejected = "arrNotification[request_rejected]"
    case message_received = "arrNotification[message_received]"
    case curr_ride_customer = "arrNotification[curr_ride_customer]"
    case curr_ride_driver = "arrNotification[curr_ride_driver]"
    case instant_booking = "arrNotification[instant_booking]"
    case cancelled_by_customer = "arrNotification[cancelled_by_customer]"
    case cancelled_by_driver = "arrNotification[cancelled_by_driver]"
    case ride_completion = "arrNotification[ride_completion]"
}

struct ResponseKey{
    
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


func showLosingerLoader(view : UIViewController, isFullScreen : Bool)
{
    //    let subviews = view.view.subviews
    //    for (subview) in subviews
    //    {
    //        if subview.tag == 10000
    //        {
    //            subview.removeFromSuperview()
    //        }
    //    }
    //    
    //    let viewForLoader = UIView()
    //    viewForLoader.tag = 10000
    //    viewForLoader.backgroundColor = UIColor(red:0.0/255.0, green:0.0/255.0, blue:0.0/255.0, alpha:0.6)
    //    let imgLoader = UIImageView()
    //    
    //    imgLoader.image = UIImage.gif(name:"loading-small")
    //    imgLoader.contentMode = .center
    //    if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    //    {
    //        if isFullScreen
    //        {
    //            viewForLoader.frame = CGRect(x: 0, y: 0, width: view.view.frame.width, height: view.view.frame.height)
    //        }
    //        else
    //        {
    //            viewForLoader.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 64, width: view.view.frame.width, height: view.view.frame.height)
    //        }
    //    }
    //    else
    //    {
    //        if isFullScreen
    //        {
    //            viewForLoader.frame = CGRect(x: 0, y:  0, width: view.view.frame.width, height: view.view.frame.height)
    //        }
    //        else
    //        {
    //            viewForLoader.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 50, width: view.view.frame.width, height: view.view.frame.height)
    //        }
    //    }
    //    imgLoader.frame = CGRect(x: 0, y: 0, width: viewForLoader.frame.width, height: viewForLoader.frame.height-100)
    //    viewForLoader.addSubview(imgLoader)
    //    view.view.addSubview(viewForLoader)
}

func hideLosingerLoader(view : UIViewController)
{
    let subviews = view.view.subviews
    for (subview) in subviews
    {
        if subview.tag == 10000
        {
            subview.removeFromSuperview()
        }
    }
}
