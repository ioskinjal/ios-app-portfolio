//
//  Modal.swift
//  APICalling
//
//  Created by Nirav Sapariya.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

enum Domain {
    static let main = "https://www.xphorm.com/"
    //https://xphorm.ncryptedprojects.com/
    //static let main = "http://192.168.100.54/petsitcare_app/"
    //    static func getPayPalUrl(amount: String) -> String{
    //        return "\(Domain.main)payment-nct/paypal-button.php?user_id=\(UserData.shared.getUser()!.user_id)&amount=\(amount)"
    //    }
}

enum EndPoint {
    
    static let login = "ws-login"
    static let register = "ws-signup"
    static let home = "ws-home"
    static let profile = "ws-profile"
    static let editProfile = "ws-edit-profile"
    static let setting = "ws-setting"
    static let language = "ws-language"
    static let search = "ws-search"
    static let givenReviews = "ws-given-reviews"
    static let receivedReviews = "ws-received-reviews"
    static let addService = "ws-add-service"
    static let myService = "ws-my-services"
     static let serviceDetail = "ws-service-detail"
    static let favServices = "ws-my-fav-services"
    static let wallet = "ws-wallet"
    static let financialInfo = "ws-financial-info"
    static let message = "ws-message"
    static let contact = "ws-contact-us"
    static let requestBook = "ws-request-book"
    static let sentRequest = "ws-sent-requests"
    static let receivedRequest = "ws-received-requests"
    static let notificationType = "ws-notification-settings"
    static let notificationList = "ws-notification-list"
    static let contentPages = "ws-content_pages"
    static let testimonials = "ws-testimonials"
    
   
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
    
    
    
    func home(vc:UIViewController?,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.home, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func profile(vc:UIViewController,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.profile, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func search(vc:UIViewController,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
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
    
    func getMyService(vc:UIViewController?,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.myService, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getGivenReviews(vc:UIViewController?,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.givenReviews, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getReceivedReviews(vc:UIViewController?,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.receivedReviews, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func EditProfileWithoutImage(vc:UIViewController?,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
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
    
   
    func EditProfile(vc:UIViewController, param: dictionary, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](),postImage: UIImage?, imageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.editProfile, parameter: param, withPostImage: postImage, withPostImageName: imageName,isboth:true, withPostImageAry: postImgsAry, withPostImageNameAry: imgNameAry, withParamName: "uploadedCerti",withparamUpload:"uploadedFile") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
        
    }
    
    func EditProfileOnlyCertificate(vc:UIViewController, param: dictionary, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](),postImage: UIImage?, imageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.editProfile, parameter: param, withPostImage: postImage, withPostImageName: imageName,isboth:false, withPostImageAry: postImgsAry, withPostImageNameAry: imgNameAry, withParamName: "uploadedCerti",withparamUpload:"uploadedFile") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
        
    }
    
    func EditProfileWithoutImageArray(vc:UIViewController, param: dictionary,postImage: UIImage?, imageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.editProfile, parameter: param, withPostImage: postImage, withPostImageName: imageName, withParamName: "uploadedFile") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
        
    }
    
    
    
    
    
    
    func setting(vc:UIViewController,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.setting, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getLanguage(vc:UIViewController,param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.language, parameter: param) { (result) in
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
    let param = param
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

    func addService(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.addService, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }

    func addServiceImage(vc:UIViewController, param: dictionary,withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](), failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.addService, parameter: param, withPostImage: nil, withPostImageName: "",isboth:false,withPostImageAry: postImgsAry, withPostImageNameAry: imgNameAry, withParamName: "uploadImages",withparamUpload:"") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func serviceDetail(vc:UIViewController?, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.serviceDetail, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getFavorite(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.favServices, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getWallet(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.wallet, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getFinancialInfo(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.financialInfo, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getMessages(vc:UIViewController?, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.message, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func conatct(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.contact, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func requestBook(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.requestBook, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func sentRequest(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.sentRequest, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func receivedRequest(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.receivedRequest, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func notificationType(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.notificationType, parameter: param) { (result) in
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
        WebRequester.shared.requests(url: Domain.main + EndPoint.notificationList, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getContentPages(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.contentPages, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getTestimonials(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.testimonials, parameter: param) { (result) in
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
                            vc.open(scheme:UIApplication.openSettingsURLString)
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

