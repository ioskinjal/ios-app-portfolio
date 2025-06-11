//
//  Modal.swift
//  APICalling
//
//  Created by Nirav Sapariya.
//  Copyright © 2018 NMS. All rights reserved.
//

import UIKit


struct Domain {
    private init() {}
    static let main = "https://davidevent.ncryptedprojects.com/admin/api/"
    static let local = "192.168.100.79/eventbooking/admin/api/"
}

enum EndPoint:String {
    case signup = "signup"
    case login = "login"
    case forgotPassword = "forgot-password"
    case socialSignup = "social-signup"
    case changePassword = "change-password"
    case contactUs = "contact-us"
    case logoutUserFromSite = "logout-user-from-site"
    case deleteUserFromSite = "delete-user-from-site"
    case getUserOrganizers = "get-user-organizers"
    case getLanguages = "get-languages"
    case addNewUserOrganizer = "add-new-user-organizer"
    case getUserTickets = "get-user-tickets"
    case addNewUserTicket = "add-new-user-ticket"
    case getCategories = "get-categories"
    case getSubCategories = "get-sub-categories"
    case getEventTypes = "get-event-types"
    case getCities = "get-cities"
    case getStates = "get-states"
    case getCountries = "get-countries"
    case createEvent = "create-event"
    case draftedCreateEvent = "drafted-create-event"
    case editEventSubmit = "edit-event-submit"
    case userEditProfile = "user-edit-profile"
    case searchEvents = "search-events"
    case editUserTicket = "edit-user-ticket"
    case checkEventTicket = "check-event-ticket"
    case getPopularCategories = "get-popular-categories"
    case editUserOrganizer = "edit-user-organizer"
    
    //
    case userProfile = "user-profile"
    case upcomingEvents = "upcoming-events"
    case popualrEvents = "popular-events"
    case favUnFav = "add-remove-favorite-events"
    case savedEvents = "my-saved-events"
    case removeSavedEvents = "remove-saved-events"
    case similarEvents = "similar-events"
    case getNotificationSettings = "get-notification-settings"
    case changeNotificationSettings = "change-notification-settings"
    case deleteOrgenizer = "delete-user-organizer"
    case deleteTickets = "delete-user-ticket"
    case myCreatedEvents = "my-created-events"
    case deleteMyCreatedEvents = "delete-my-created-event"
    case paymentHistory = "my-payment-histories"
    case mySoldTickets = "my-sold-tickets"
    case deleteSoldTickets = "delete-my-sold-tickets"
    case followers = "get-user-followers"
    case followUnfollow = "add-remove-follow-unfollow"
    case getFollowings = "get-user-followings"
    case orgenizerDetail = "organizer-detail-page"
    case eventDetail = "event-detail"
    case myFavEvent = "my-favorite-events"
    case myContactList = "get-my-contact-lists"
    case createConatctListName = "create-contact-list-name"
    case editContactListName = "edit-contact-list-name"
    case AddContactListEmail = "create-contact-list-name-email"
    case DeleteContactListEmail = "delete-contact-list-name-email"
    case deleteContactListName = "delete-contact-list-name"
    case myPurchasedTickets = "my-purchase-tickets"
    case reportEvent = "report-event"
    case getContactListName = "get-my-contact-list-names"
    case inviteContact = "invite-via-my-contacts"
    case myPurchasedEvents = "my-purchase-events"
    case cmsPages = "get-all-cms-pages"
    case addBackImage = "add-event-back-image"
    case deleteBackImage = "delete-event-back-image"
    
}

typealias failureBlock = (String) -> Void
typealias successBlock = ([String:Any]) -> Void

class API {
    private init(){}
    static let shared = API()
    
    static var sharedAppdelegate:AppDelegate {
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    static func addLanguageId(param: dictionary) -> dictionary{
        var param = param
        param["lan_code"] = UserData.shared.languageID
        return param
    }
    
    
   
    
    func attachFile(_ vc:BaseViewController?,param:dictionary,isLoader:Bool,isUploadImage:Bool = true,imageName:String?,image:UIImage?,fileData:Data?,fileName:String?,failer:failureBlock? = nil,success:@escaping successBlock){
      
        WebRequester.shared.requestsWithAttachments(url: Domain.main + EndPoint.addBackImage.rawValue, method: .post,  parameter: param, withParamName: "event_back_image", withPostImage: image, withPostImageName: imageName,  isLoader: isLoader) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
        
    }
        

    func call(with endPoint: EndPoint, viewController vc:UIViewController?, param: dictionary,
              failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + endPoint.rawValue, parameter: API.addLanguageId(param: param)) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func call(with endPoint: EndPoint? = nil, viewController vc:UIViewController?, param: dictionary, isLoader:Bool = true, isRapidCall:Bool = true, isRetry:Bool = true,
              failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: (endPoint == nil ? Domain.main : Domain.main + endPoint!.rawValue), parameter: API.addLanguageId(param: param), isLoader: isLoader, isRapidCall: isRapidCall, isRetry:isRetry) { (result) in
            let responce = self.checkResponce(vc: vc, isLoader: isLoader, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func callAttachment(with endPoint: EndPoint? = nil, viewController vc:UIViewController?, param: dictionary, isLoader:Bool = true, isRapidCall:Bool = true, isRetry:Bool = true,
                        fileData: Data?, fileName:String?, withParamName: String,
                        failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithAttachments(url: (endPoint == nil ? Domain.main : Domain.main + endPoint!.rawValue), parameter: API.addLanguageId(param: param), withParamName: withParamName, withFileData: fileData, withFileName: fileName, isLoader: isLoader, isRapidCall: isRapidCall, isRetry:isRetry) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
        
    }
    
    func callImageAttachment(with endPoint: EndPoint? = nil, viewController vc:UIViewController?, param: dictionary, isLoader:Bool = true, isRetry:Bool = true,
                        image: UIImage?, imageName:String?, withParamName: String,
                        failer:failureBlock? = nil, success:@escaping successBlock ){
        //isRapidCall always set false in attachment API
        WebRequester.shared.requestsWithAttachments(url: (endPoint == nil ? Domain.main : Domain.main + endPoint!.rawValue),
                                                    parameter: param, withParamName: withParamName,
                                                    withPostImage: image, withPostImageName: imageName,
                                                    isLoader: isLoader, isRapidCall: false, isRetry: isRetry) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
}


extension API{
    
    private func checkResponce(vc: UIViewController?, isLoader:Bool = true, result: APIResult<Any>) -> (isSuccess:Bool, dic:dictionary? ,message:String?) {
        if isLoader { API.sharedAppdelegate.stopLoader() }
        switch result {
        case .success(let val):
            if (val as! dictionary)[keys.status.rawValue] as? Bool ?? false{
                //Store access token in userDefault
                let authToken = ResponseHandler.fatchDataAsString(res: val as! dictionary, valueOf: .authToken)
                if !authToken.isBlank{
                    //UserData.shared.setAccessToken(accessToken: authToken)
                }
                return (isSuccess: true, dic: val as? dictionary, message: nil)
            }else{
                guard let message = (val as! dictionary)[keys.message.rawValue] as? String else { //server side respose false
                    print("Status is false but can't get error message")
                    return (isSuccess: false, dic: nil, message: nil)
                }
                if let _ = vc, let errcode = (val as! dictionary)[keys.statusCode.rawValue] as? String, errcode == ErrorCode.unauthorized{
                    UIApplication.alert(title: "", message: message) {
                        //FIXME: Logout user
                    }
                }
                else if let _ = vc, let errcode = (val as! dictionary)[keys.statusCode.rawValue] as? String, errcode != ErrorCode.NoData{
                    UIApplication.alert(title: "", message: message)
                }
                print( "Server response false: \((val as! dictionary)[keys.message.rawValue] as? String ?? ""))")
                return (isSuccess: false, dic: nil, message: message)
            }
        case .failure(let error):
            let strErr = error.localizedDescription
            if strErr == "The Internet connection appears to be offline." {//strErr == "Could not connect to the server." ||
                if let _ = vc{
                    //vc.alert(title: "", message: strErr)
                    DispatchQueue.updateUI_InMainThread {
                        UIApplication.alert(title: "", message: strErr, actions: ["Cancel","Settings"], completion: { (flag) in
                            if flag == 1{ //Settings
                                vc!.open(scheme:UIApplication.openSettingsURLString)
                            }
                            else{ //== 0 Cancel
                            }
                        })
                    }
                }
            }else{
                #if DEBUG
                if let _ = vc{
                    DispatchQueue.updateUI_InMainThread {
                        UIApplication.alert(title: "Server Error", message: strErr) {}                        
                    }
                }
                #endif
            }
            return (isSuccess: false, dic: nil, message: strErr)
        }
    }
    
}

//MARK:- Constants
public enum APIResult<T> {
    case success(T)
    case failure(Error)
}

enum keys:String  {
    case status = "status"
    case message = "message"
    case data = "data"
    case statusCode = "status_code"
    case getContactListNameDetails = "getContactListNameDetails"
    case authToken = "auth_token"
    
    //case
    //
    case ticketsArray = "ticketsArray"
    case organizersArray = "organizersArray"
    case is_user_like = "is_user_like"
    case is_user_follow = "is_user_follow"
    case getAllBackImages = "getAllBackImages"
}

struct ErrorCode {
    static let success = "200"
    static let fail = "400"
    static let NoData = "301"
    static let unauthorized = "401"
}

struct ResponseHandler{
    private init() { }
    
    static func fatchDataAsDictionary(res: dictionary, valueOf key: keys) -> [String:Any] {
        if res[key.rawValue] as? [String:Any] != nil{
            //print("Dictionary as a response")
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
            //print("Array as a response")
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
            //print("String as a response")
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



