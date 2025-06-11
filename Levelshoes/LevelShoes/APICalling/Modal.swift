//
//  Modal.swift
//  APICalling
//
//  Created by Nirav Sapariya.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

enum Domain {
   // static let main = "https://touristpass.ncryptedprojects.com/api-nct/"
    static let main = "http://magento2.idslogic.net/rest/ae_en/V1/integration/customer/token"
    //    static func getPayPalUrl(amount: String) -> String{
    //        return "\(Domain.main)payment-nct/paypal-button.php?user_id=\(UserData.shared.getUser()!.user_id)&amount=\(amount)"
    //    }
}

enum EndPoint {
    
    static let login = "login-nct.php"
    static let register = "signup-nct.php"
    static let Profile = "profile-nct.php"
    static let editProfile = "edit_profile.php"
    static let logout = "logout-nct.php"
  
    static let home = "home-nct.php"
    static let account = "account-nct.php"
    static let postedBusiness = "merchant-account-nct.php"
    static let search = "search-nct.php"
    static let inviteFriend = "user-account-nct.php"
    static let postBusiness = "post_business-nct.php"
    static let merchantProfile = "merchant-profile-nct.php"
    static let businessDetail = "business-detail-nct.php"
    static let postAdvetise = "post-advertisement-nct.php"
    static let postedAd = "advertisements-nct.php"
    static let paymentHistory = "payment-history-nct.php"
    static let memberShipPlan = "membership-plan-nct.php"
    static let messages = "messages-nct.php"
    static let setFavorite = "business-nct.php"
    static let notification = "notifications-nct.php"
   
 


  
    
    }

typealias failureBlock = (String) -> Void
typealias successBlock = ([String:Any]) -> Void

class Modal {
    static let shared = Modal()
    
    static var sharedAppdelegate:AppDelegate {
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    
    
    func resetPwd(vc:UIViewController,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requestsPut(url: Domain.main, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    
    
    func getProfile(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.Profile, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func editProfile(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.editProfile, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    
   
    func logOut(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
                WebRequester.shared.requests(url: Domain.main + EndPoint.logout, parameter: param) { (result) in
                    let responce = self.checkResponce(vc: vc, result: result)
                    if responce.isSuccess {
                        success(responce.dic!)
                    }
                    else {
                        failer?(responce.message!)
                    }
                }
            }
    
    func account(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.account, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func favUnfav(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.setFavorite, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getPaymentHistory(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.paymentHistory, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getMessages(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.messages, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func ediProfile(vc:UIViewController, postImage: UIImage?,param:dictionary, imageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.account, parameter:param, withPostImage: postImage, withPostImageName: imageName, withParamName: "profile_image") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func postAdvertisement(vc:UIViewController, postImage: UIImage?,param:dictionary, imageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.postAdvetise, parameter:param, withPostImage: postImage, withPostImageName: imageName, withParamName: "image") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func checkPrice(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.postAdvetise, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func postedAdvertisement(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.postedAd, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }

func login(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
    //Modal.sharedAppdelegate.startLoader()
    var param = param
   // param["device_type"] = "i"
   // param["device_token"] = UserData.shared.deviceToken
    WebRequester.shared.requests(url: Domain.main + EndPoint.login, parameter: param) { (result) in
        let responce = self.checkResponce(vc: vc, result: result)
        if responce.isSuccess {
            success(responce.dic!)
        }
        else {
            failer?(responce.message!)
        }
    }
}

func signUp(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
    WebRequester.shared.requests(url: Domain.main + EndPoint.register, parameter: param) { (result) in
        let responce = self.checkResponce(vc: vc, result: result)
        if responce.isSuccess {
            success(responce.dic!)
        }
        else {
            failer?(responce.message!)
        }
    }
}

    func editProfileNoImage(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.account, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func postedBusiness(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.postedBusiness, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func searchBusiness(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.search, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func inviteFriends(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.inviteFriend, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func postBusiness(vc:UIViewController, param: dictionary, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](), failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.postBusiness, parameter: param, withPostImage: nil, withPostImageName: nil, withPostImageAry: postImgsAry, withPostImageNameAry: imgNameAry, withParamName: "image") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
        
    }
    
    func getEditBusiness(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.postBusiness, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getMemberShipPlan(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.memberShipPlan, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getMerchantProfile(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.merchantProfile, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }

    func editMerchantProfile(vc:UIViewController, postImage: UIImage?,param:dictionary, imageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.postedBusiness, parameter:param, withPostImage: postImage, withPostImageName: imageName, withParamName: "profile_image") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func editMerchantProfileWithoutImg(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.postedBusiness, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func deleteMedia(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.postBusiness, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func businessDetail(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.businessDetail, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    
    func getNotifications(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.notification, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }

//    func autoLogin(param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
//        //Modal.sharedAppdelegate.startLoader()
//        var param = param
//        param["device_type"] = "i"
//        param["device_token"] = UserData.shared.deviceToken
//        WebRequester.shared.requests(url: Domain.main + EndPoint.login, parameter: param, isLoader: false) { (result) in
//            let responce = self.checkResponce(vc: nil, result: result)
//            if responce.isSuccess {
//                success(responce.dic!)
//            }
//            else {
//                failer?(responce.message!)
//            }
//        }
//    }


}


extension Modal{
    
    private func checkResponce(vc: UIViewController?, result: Result<Any>) -> (isSuccess:Bool, dic:dictionary? ,message:String?) {
        Modal.sharedAppdelegate.stoapLoader()
        switch result {
        case .success(let val):
            if (val as! dictionary)[keys.status.rawValue] as? Bool ?? false{
                return (isSuccess: true, dic: val as? dictionary, message: nil)
            }else{
                guard let message = (val as! dictionary)[keys.message.rawValue] as? String else { //server side respose false
                    print("Status is false but can't get error message")
                    return (isSuccess: false, dic: nil, message: nil)
                }
                if let vc = vc{
                    vc.alert(title: "", message: message)
                }
                return (isSuccess: false, dic: nil, message: message)
            }
        case .failure(let error):
            let strErr = error.localizedDescription
            if strErr == "The Internet connection appears to be offline." {//strErr == "Could not connect to the server." ||
                if let vc = vc{
                    vc.alert(title: "", message: strErr, actions: ["Cancel","Settings"], completion: { (flag) in
                        if flag == 1{ //Settings
                            vc.open(scheme:UIApplicationOpenSettingsURLString)
                        }
                        else{ //== 0 Cancel
                        }
                    })
                }
            }
            return (isSuccess: false, dic: nil, message: strErr)
        }
    }
}

