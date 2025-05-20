//
//  Modal.swift
//  APICalling
//
//  Created by Nirav Sapariya.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

enum URLConstants {
   // static let API_URL = "http://bipani.ncryptedprojects.com/"
    //http://justinthumbpin.ncryptedprojects.com/
    //http://dev.ncryptedprojects.com/thumbpin/
    static let API_URL = "http://justinthumbpin.ncryptedprojects.com/"
}

enum Action {
   // static let pre_paypal = "pre_paypal"
    static let signup = "signup"
    static let login = "login"
    static let forgotpassword = "forgot-password"
    static let sendReactivateEmail = "send_reactivate_email"
    static let serviceList = "service_list"
    static let getTopCategory = "getTopCategory"
    static let getProfile = "profile"
    static let editProfile = "edit_profile"
    static let getProject = "getProject"
    static let reponeService = "repone_service"
    static let getLists = "getLists"
    static let updateService = "update_service"
    static let getCategory = "getCategory"
    static let getSubCategory = "getSubCategory"
    static let getQuestion = "getQuestion"
    static let dependentQue = "dependent_que"
    static let postService = "post-service"
    static let getDetails = "getDetails"
    static let getNotificationList = "get_notification_list"
    static let getEmailNotification = "get_email_notification"
    static let setEmailNotification = "set_email_notification"
    static let getLanguage = "getLanguage"
    static let changePassword = "change_password"
    static let cms = "cms"
    static let sendContactus = "send_contactus"
    static let business = "business"
    static let review = "review"
    static let setStatus = "setStatus"
    static let getStatus = "getStatus"
    static let addPortfolio = "addPortfolio"
    static let deletePortfolio = "deletePortfolio"
    static let editBusinessProfile = "edit_business_profile"
    static let getNotification = "getNotification"
    static let deleteNotification = "delete_notification"
    static let getQuotePlaced = "get_quote_placed"
    static let deleteQuote = "delete_quote"
    static let getCreditRecord = "getCreditRecord"
    static let getList = "get_list"
    static let pre_paypal = "pre_paypal"
    static let getfreeplan = "get_free_plan"
    static let redeemRequest = "redeemRequest"
    static let serviceCreditDetails = "service_credit_details"
    static let postServiceQuote = "post_service_quote"
    static let getAllMessage = "getAllMessage"
    static let getCustomerDetails = "getCustomerDetails"
    static let getProviderDetails = "getProviderDetails"
    static let sendMessage = "sendMessage"
    static let hireProvider = "hireProvider"
    static let checkreviewstatus = "check_review_status"
    static let giveRate = "giveRate"
    static let logout = "logout"
    static let get_offline_data = "get_offline_data"
    static let getAppData = "getAppData"
    static let getSupplier = "getSupplier"
    static let getMaterialUnit = "getMaterialUnit"
    static let getMaterial  = "getMaterial"
    static let getAllMessageList  = "getAllMessagelist"

    
}

enum EndPoint {
    static let login = "ws-login/"
    static let signup = "ws-signup/"
    static let reactivate = "ws-reactivate/"
    static let home = "ws-home/"
    static let profile = "ws-profile/"
    static let editProfile = "ws-edit-profile/"
    static let myProjects = "ws-myprojects/"
    static let updateService = "ws-update-service/"
    static let browseCategory = "ws-browse-category/"
    static let browseSubCategory = "ws-sub-category/"
    static let requestService = "ws-request/"
    static let requestDetails = "ws-details/"
    static let notificationList = "ws-site-notification/"
    static let emailNotification = "ws-email-notification/"
    static let languageList = "ws-language/"
    static let changePass = "ws-cpass/"
    static let contactUs = "ws-contactus/"
    static let flagSet = "ws-flag/"
    static let portfolio = "ws-portfolio/"
    static let serviceNotifications = "ws-service-notification/"
    static let quotePlaced = "ws-quote-placed/"
    static let membership = "ws-membership-plan/"
    static let paypal = "ws-paypal/"
    static let prepaypal = "ws-paynow/"
    static let messageRoom = "ws-message-room/"
    static let messageRoomProvider = "ws-message-room-provider/"
    static let messageRoomCustomer = "ws-message-room-customer/"
    static let review = "ws-review/"
    static let offline = "ws-offline/"
    static let appdata = "ws-app-data/"
    static let searchProvider = "ws-search"
    static let materialList = "ws-material"
    static let materialUnit = "ws-material_unit"
    static let getAllMessageList  = "ws-message"
    
}

typealias failureBlock = (String) -> Void
typealias failureBlockDict = ([String:Any]) -> Void
typealias successBlock = ([String:Any]) -> Void

class ApiCaller {
    static let shared = ApiCaller()
    
    static var sharedAppdelegate:AppDelegate {
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    func getSuplier(vc:UIViewController, param: dictionary, failer: failureBlock? = nil, success:@escaping successBlock){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.searchProvider, parameter: param) { (result) in
            print(result)
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getMaterial(vc:UIViewController, param: dictionary, failer: failureBlock? = nil, success:@escaping successBlock){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.materialList, parameter: param) { (result) in
            print(result)
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getAllMessagesList(vc:UIViewController, param: dictionary, failer: failureBlock? = nil, success:@escaping successBlock){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.getAllMessageList, parameter: param) { (result) in
            print(result)
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getMaterialUnit(vc:UIViewController, param: dictionary, failer: failureBlock? = nil, success:@escaping successBlock){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.materialUnit, parameter: param) { (result) in
            print(result)
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    
    
    func logout(vc:AppDelegate, param: dictionary, failer: failureBlock? = nil, success:@escaping successBlock){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.login, parameter: param) { (result) in
            print(result)
            let responce = self.checkResponceAppdelegate(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    
    func login(vc:UIViewController, param: dictionary, failer: failureBlock? = nil, success:@escaping successBlock){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.login, parameter: param) { (result) in
            print(result)
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
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.signup, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func resendActivationMail(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.reactivate, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getServiceList(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.home, parameter: param) { (result) in
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
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.profile, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func editProfile(vc:UIViewController, param: dictionary, withPostImage:UIImage,withPostImageName: String,withParamName:String, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithImage(url: URLConstants.API_URL + EndPoint.editProfile, parameter: param, withPostImage: withPostImage, withPostImageName: withPostImageName, withParamName: withParamName) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func deletePortFolio(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.portfolio, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func addPortFolio(vc:UIViewController, param: dictionary, withPostImage:UIImage,withPostImageName: String,withParamName:String, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithImage(url: URLConstants.API_URL + EndPoint.portfolio, parameter: param, withPostImage: withPostImage, withPostImageName: withPostImageName, withParamName: withParamName) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getMyServiceList(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.myProjects, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getUpdateService(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.updateService, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func uploadDocumentFile(vc:UIViewController, param: dictionary, fileData:Data,withPostImageName: String,withParamName:String, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithFile(url: URLConstants.API_URL + EndPoint.messageRoom, parameter: param, withFileData: fileData, withPostImageName: withPostImageName, withPostImageAry: [UIImage](), withPostImageNameAry: [String](), withParamName: withParamName) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func browseCategory(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.browseCategory, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func browseSubCategory(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.browseSubCategory, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func requestService(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.requestService, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func requestServiceDependent(vc:UITableViewCell, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.requestService, parameter: param) { (result) in
            let responce = self.checkResponceCell(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func postRequestService(vc:UIViewController, param: dictionary,withFileData:Data, withFileName: String,failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithFileData(url: URLConstants.API_URL + EndPoint.requestService, parameter: param, withFileData: withFileData, withFileName: withFileName, withParamName: "pdf_file") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
                if responce.isSuccess {
                    success(responce.dic!)
                }
                else {
                    failer?(responce.message!)
                }
        }
    }
    func requestDetails(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.requestDetails, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func notificationList(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.notificationList, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func emailNotification(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.emailNotification, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func geLanguageList(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.languageList, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func changePassword(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.changePass, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func contactUs(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.contactUs, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func setFlagStatus(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.flagSet, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getCategoryProfile(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.profile, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func editBusinessProfile(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.editProfile, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getServiceNotifications(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.serviceNotifications, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getQuoetdPlaced(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.quotePlaced, parameter: param) { (result) in
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
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.membership, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getPaymentUrl(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.paypal, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getPrePaymentUrl(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.prepaypal, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getAllMessages(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.messageRoom, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getCustomerDetail(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.messageRoomProvider, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getProviderDetail(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.messageRoomCustomer, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func uploadDocument(vc:UIViewController, param: dictionary,fileName: String, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestMultipartFormDataWithImageAndDocument(URLConstants.API_URL + EndPoint.messageRoom, dicsParams: param, fileName) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func uploadDocumentImage(vc:UIViewController, param: dictionary, withPostImage:UIImage,withPostImageName: String,withParamName:String, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithImage(url: URLConstants.API_URL + EndPoint.messageRoom, parameter: param, withPostImage: withPostImage, withPostImageName: withPostImageName, withParamName: withParamName) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func uploadDocumentFile1(vc:UIViewController, param: dictionary, fileData:Data,withPostImageName: String,withParamName:String, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithFile(url: URLConstants.API_URL + EndPoint.getAllMessageList, parameter: param, withFileData: fileData, withPostImageName: withPostImageName, withPostImageAry: [UIImage](), withPostImageNameAry: [String](), withParamName: withParamName) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func uploadDocumentImage1(vc:UIViewController, param: dictionary, withPostImage:UIImage,withPostImageName: String,withParamName:String, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithImage(url: URLConstants.API_URL + EndPoint.getAllMessageList, parameter: param, withPostImage: withPostImage, withPostImageName: withPostImageName, withParamName: withParamName) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getReviews(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: URLConstants.API_URL + EndPoint.review, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getOfflineData(param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsOffline(url: URLConstants.API_URL + EndPoint.offline, parameter: param) { (result) in
            let responce = self.checkResponceAppdelegate(result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getApplicationData(param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsOffline(url: URLConstants.API_URL + EndPoint.appdata, parameter: param) { (result) in
            let responce = self.checkResponceAppdelegate(result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
}


extension ApiCaller {
    
    private func checkResponceCell(vc: UITableViewCell, result: Result<Any>) -> (isSuccess:Bool, dic:dictionary? ,message:String?) {
        AppHelper.hideLoadingView()
        switch result {
        case .success(let val):
            if (val as! dictionary)[keys.status.rawValue] as? Bool ?? false{
                return (isSuccess: true, dic: val as? dictionary, message: nil)
            }else{
                guard let message = (val as! dictionary)[keys.message.rawValue] as? String else {
                    print("Status is false but can't get error message")
                    return (isSuccess: false, dic: nil, message: nil)
                }
                //  vc.alert(title: "", message: message)
                return (isSuccess: false, dic: val as? dictionary, message: message)
            }
        case .failure(let error):
            let strErr = error.localizedDescription
            /*    if strErr == "The Internet connection appears to be offline." {//strErr == "Could not connect to the server." ||
             vc.alert(title: "", message: strErr, actions: ["Cancel","Settings"], completion: { (flag) in
             if flag == 1{ //Settings
             vc.open(scheme:UIApplicationOpenSettingsURLString)
             }
             else{ //== 0 Cancel
             }
             })
             }     */
            return (isSuccess: false, dic: nil, message: strErr)
        }
    }
    
    private func checkResponce(vc: UIViewController, result: Result<Any>) -> (isSuccess:Bool, dic:dictionary? ,message:String?) {
        AppHelper.hideLoadingView()
        switch result {
        case .success(let val):
            if (val as! dictionary)[keys.status.rawValue] as? Bool ?? false{
                return (isSuccess: true, dic: val as? dictionary, message: nil)
            }else{
                guard let message = (val as! dictionary)[keys.message.rawValue] as? String else {
                    print("Status is false but can't get error message")
                    return (isSuccess: false, dic: nil, message: nil)
                }
              //  vc.alert(title: "", message: message)
                return (isSuccess: false, dic: val as? dictionary, message: message)
            }
        case .failure(let error):
            let strErr = error.localizedDescription
        /*    if strErr == "The Internet connection appears to be offline." {//strErr == "Could not connect to the server." ||
                vc.alert(title: "", message: strErr, actions: ["Cancel","Settings"], completion: { (flag) in
                    if flag == 1{ //Settings
                        vc.open(scheme:UIApplicationOpenSettingsURLString)
                    }
                    else{ //== 0 Cancel
                    }
                })
            }     */
            return (isSuccess: false, dic: nil, message: strErr)
        }
    }
    private func checkResponceAppdelegate(result: Result<Any>) -> (isSuccess:Bool, dic:dictionary? ,message:String?) {
        AppHelper.hideLoadingView()
        switch result {
        case .success(let val):
            if (val as! dictionary)[keys.status.rawValue] as? Bool ?? false{
                return (isSuccess: true, dic: val as? dictionary, message: nil)
            }else{
                guard let message = (val as! dictionary)[keys.message.rawValue] as? String else {
                    print("Status is false but can't get error message")
                    return (isSuccess: false, dic: nil, message: nil)
                }
                //  vc.alert(title: "", message: message)
                return (isSuccess: false, dic: val as? dictionary, message: message)
            }
        case .failure(let error):
            let strErr = error.localizedDescription
            /*    if strErr == "The Internet connection appears to be offline." {//strErr == "Could not connect to the server." ||
             vc.alert(title: "", message: strErr, actions: ["Cancel","Settings"], completion: { (flag) in
             if flag == 1{ //Settings
             vc.open(scheme:UIApplicationOpenSettingsURLString)
             }
             else{ //== 0 Cancel
             }
             })
             }     */
            return (isSuccess: false, dic: nil, message: strErr)
        }
    }
    
    private func checkResponceAppdelegate(vc: AppDelegate, result: Result<Any>) -> (isSuccess:Bool, dic:dictionary? ,message:String?) {
        AppHelper.hideLoadingView()
        switch result {
        case .success(let val):
            if (val as! dictionary)[keys.status.rawValue] as? Bool ?? false{
                return (isSuccess: true, dic: val as? dictionary, message: nil)
            }else{
                guard let message = (val as! dictionary)[keys.message.rawValue] as? String else {
                    print("Status is false but can't get error message")
                    return (isSuccess: false, dic: nil, message: nil)
                }
                //  vc.alert(title: "", message: message)
                return (isSuccess: false, dic: val as? dictionary, message: message)
            }
        case .failure(let error):
            let strErr = error.localizedDescription
            /*    if strErr == "The Internet connection appears to be offline." {//strErr == "Could not connect to the server." ||
             vc.alert(title: "", message: strErr, actions: ["Cancel","Settings"], completion: { (flag) in
             if flag == 1{ //Settings
             vc.open(scheme:UIApplicationOpenSettingsURLString)
             }
             else{ //== 0 Cancel
             }
             })
             }     */
            return (isSuccess: false, dic: nil, message: strErr)
        }
    }
    
}

