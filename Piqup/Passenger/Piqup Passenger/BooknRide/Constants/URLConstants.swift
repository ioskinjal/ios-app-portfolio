//
//  URLConstants.swift
//  BooknRide
//
//  Created by NCrypted on 01/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

struct StoryBoard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let imageCropper  = UIStoryboard(name: "ImageCropper", bundle: nil)
}

extension UIViewController{
    
    static var identifier: String {
        return String(describing: self)
    }
}

class URLConstants: NSObject {
    
    public struct Domains{

        static let ServiceUrl = "http://piqup.ncryptedprojects.com:3010/"
        static let CarUrl = "http://piqup.ncryptedprojects.com/themes-nct/images-nct/carType/"
        static let SubCarUrl = "http://piqup.ncryptedprojects.com/booknride/themes-nct/images-nct/subCarType/"
        static let HelpUrl = "http://booknrideenter.ncryptedprojects.com:4100/help/user"
        
        static let trackingUrl = "wss://piqup.ncryptedprojects.com:5010/"

        static let profileUrl = Domains.ServiceUrl+"images/profileImage/"
        static let pdfDownload = "http://booknrideenter.ncryptedprojects.com:4100/documents/"
    }
    

    public struct User{
        
        static let register = "userregister"
        static let login = "userlogin"
        static let logout = "logout"
        static let forgotPassword = "forgatpassword"
        static let chnagePassowrd = "changepassword"
        static let getCms = "getcms"
        static let profile = "getuserprofile"
        static let editUpdateProfile = "usereditprofile"
        
        static let getLocation = "usergetlocation"
        static let editLocation = "usereditlocation"
        static let deleteLocation = "userdeletelocation"
        
        static let defaultPaymentMethod = "userdefaultpaymentmethod"
        
        static let countryCode = "getcountrycode"
        static let getLanguage = "get_language"
        static let languageConst = "language_const"
        static let getlogisticdetails = "getlogisticdetails"
        
        
    }
    
    public struct Social{
        
        static let login = "sociallogin"
    }
    
    public struct Wallet{
        
        static let getDetails = "getuserwalletdetails"
        static let redeemRequest = "userredeemrequest"
        static let getBalance = "getuserbalance"
        
        static let depositFund = "depositfund"
        static let paymentRequest = "payment_request"
        static let redeemHistory = "getredeemhistory"
        static let checkWalletAmount  = "checkWalletAmount"
    }
    
    public struct Trip{
        
        static let getTripList = "getusertriplist"
        static let getUserTripDetails = "usertripdetails"
        static let addUserFeedback = "useraddfeedback"
        static let getPathString = "getpathstring"
        
    }
    
    public struct Ride{
        static let getUserRideInfo = "userrideinfo"
         static let cancelScheduledRide = "cancelScheduledRide"
        
    }
    
    public struct Car{
        
        static let getCarType = "usergetcartype"
        static let getSubCarType = "getsubcartypes"
        static let getbrands = "getbrands"
        
        
    }
    
    public struct Book{
        static let confirmRide = "conformride"
    }
    
    public struct Cancel{
        
        static let cancelRide = "cancelride"
    }
    public struct Track{
        
        static let driverInBackground = "getbackground"
    }
    
    public struct Fare{
        
        static let estimate = "fareestimate"
        static let summary = "faresummery"
        static let getFareSummary = "getfaresummery"
        
    }
    
    public struct Panic{
        
        static let editContact = "editpanicnumber"
        static let setPaniceRide = "setpanicride"
        static let getPanicNumber = "getpanicnumber"
        
        
    }
    
    public struct Partener{
        static let report = "reportdriver"
    }
    
    public struct UserDefaults{
        
        static let BooknRideService = "BooknRideUser"
    }
    
    public struct Contact{
        static let contactUs = "contactus"
        
    }
    
    public struct Notification{
        
        static let getNotification = "getnotification"
    }
    
    public struct Device{
        
        static let registerDevice = "registerdevice"
        
    }
    
    public struct Settings{
        static let getAccountSettings = "getaccountsetting"
        static let updateAccountSettings = "updateaccountsetting"
        static let editpaypalemail = "editpaypalemail"
        
        
    }
    
    public struct WebPages{
        static let getcms = "getcms"
        static let getcmsList = "getcmslist"
        static let userHelp = "userHelp"
    }
    
}

class LogisticsList: NSObject{
    
    private let keys = ["id", "name","isActive","createdDate"]
    
    @objc var id = ""
    @objc var name = ""
    @objc var isActive = ""
    @objc var createdDate = ""
   
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        name = dic["name"] as? String ?? ""
        isActive = dic["isActive"] as? String ?? ""
        createdDate = dic["createdDate"] as? String ?? ""
        
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    var dictionary:[String:Any] {
        return self.dictionaryWithValues(forKeys: keys)
    }
    
}


enum keys:String
{
    case status = "status"
    case message = "message"
    case data = "data"
    case dataAns = "dataAns"
    case products = "products"
    case followerList = "followerList"
    
    
}


