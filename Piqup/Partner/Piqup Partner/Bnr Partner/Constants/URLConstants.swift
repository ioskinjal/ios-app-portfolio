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
    }
    
    public struct User{
        
        
        static let register = "partnerregister"
        static let login = "partnerlogin"
        static let logout = "logout"
        static let forgotPassword = "forgatpassword"
        static let chnagePassowrd = "changepassword"
        static let getCms = "getcms"
        
        static let profile = "getpartnerprofile"
        static let editUpdateProfile = "partnereditprofile"

        static let getLocation = "usergetlocation"
        static let editLocation = "usereditlocation"
        static let deleteLocation = "userdeletelocation"
        
        static let defaultPaymentMethod = "userdefaultpaymentmethod"
        
        static let redeemHistory = "getredeemhistory"
        static let countryCode = "getcountrycode"
        static let getLanguage = "get_language"
        static let languageConst = "language_const"

    }
    
    public struct OnlineOffline{
        static let partnerGoOnline = "partnergoonline"
        static let partnerGoOffline = "partnergooffline"
        static let offlineService = "offlineservice"
    }
    
    public struct Social{
        
        static let login = "sociallogin"
    }

    public struct Wallet{
        
        static let getDetails = "getuserwalletdetails"
        static let redeemRequest = "userredeemrequest"
        static let getBalance = "getuserbalance"
        
        static let depositFund = "depositfund"

    }
    
    public struct Trip{
        
        static let getTripList = "getpartnertriplist"
        static let getUserTripDetails = "partnerridedetails"
        static let addUserFeedback = "useraddfeedback"
        static let getPathString = "getpathstring"

    }
    
    public struct Finance{
        static let getPartnerFinancialInfo = "partnerfinancialinfo"
        static let getPartnerFinancialInfoFilter = "partnerfinancialinfofilter"
    }
    
    public struct Brand{
        
        static let getBrands = "getbrands"
    }
    
    public struct Ride{
        static let getUserRideInfo = "userrideinfo"
        static let partnerAcceptRide = "partneracceptride"
        static let startRide = "startride"
        static let cancelRide = "cancelride"
        static let getStartRideTimestamp = "getstartridetimestamp"
        static let sendVerificationCode = "sendVerificationCode"
        static let verifyCode = "verifyCode"
        
    }
    
    public struct Car{
        
        static let getCars = "getcars"
        static let addCar = "addcar"
        static let editCar = "editcar"
        static let deleteCar = "deletecar"

        static let getCarType = "usergetcartype"
        static let getSubCarType = "getsubcartypes"

    }
    
    public struct Book{
    static let confirmRide = "conformride"
    }
    
 
    public struct Track{
        
        static let driverInBackground = "getbackground"
    }
    
    public struct Fare{

        static let estimate = "fareestimate"
        static let summary = "faresummery"
    }
    
    public struct Panic{
        
        static let editContact = "editpanicnumber"
        static let setPaniceRide = "setpanicride"
        static let getPanicNumber = "getpanicnumber"
        

    }
    
    public struct Partener{
        static let report = "reportuser"
        static let updatePartnerLatLongWithRide = "updatepartnerlatlongwithride"
        static let updatePartnerLatLong = "updatepartnerlatlong"

        static let partnerStatus = "partnerstatus"
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
