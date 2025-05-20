
//
//  modelClass.swift
//  ConnectIn
//
//  Created by NCrypted on 16/05/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

enum Domain {
    static let url = "http://mishop.ncryptedprojects.com/ws/"
    
    //    static func getPayPalUrl(amount: String) -> String{
    //        return "\(Domain.main)payment-nct/paypal-button.php?user_id=\(UserData.shared.getUser()!.user_id)&amount=\(amount)"
    //    }
}

enum EndPoint {
    static let register = "profile/register"
    static let login = "profile/login"
    static let changePassword = "profile/changepassword"
    static let forgetPassword = "profile/forgetpassword"
    static let myBid = "products/mybid"
    static let pastPartyList = "party/pastpartylist"
    static let upcomingPartyList = "party/upcomingpartylist"
    static let currentPartyList = "party/currentpartylist"
    static let countryList = "region/country"
    static let stateList = "region/state"
    static let myProfile = "profile/myprofile"
    static let editProfile = "profile/editprofile"
    static let aboutUs = "aboutus/getaboutus"
    static let myShop = "products/myshop"
    static let deleteProduct = "products/deleteproduct"
    static let getFollowerList = "profile/myfollower"
    static let getFollowingList = "profile/myfollowing"
    static let FollowUser = "products/follow"
    static let UnFollowUser = "products/unfollow"
    static let getcategory = "category/getcategory"
    static let getSize = "size/getsizelist"
    static let addProduct = "products/addproduct"
    static let getBrand = "brand/getbrand"
    static let getProductDetail = "products/productdetail"
    static let addNewParty = "party/addnewparty"
    
}

typealias failureBlock = (String) -> Void
typealias successBlock = ([String:Any]) -> Void

class ModelClass {
    static let shared = ModelClass()
    
    static var sharedAppdelegate:AppDelegate {
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
}
    func login(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
      //  var param = param
      //  param["device_type"] = "i"
        //param["device_token"] = UserData.shared.deviceToken
        WebRequester.shared.requests(url: Domain.url + EndPoint.login, parameter: param) { (result) in
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
        WebRequester.shared.requests(url: Domain.url + EndPoint.register, parameter: param) { (result) in
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
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.changePassword, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func forgetPassword(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
       WebRequester.shared.requests(url: Domain.url + EndPoint.forgetPassword, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getMyBid(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.myBid, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getPastParty(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.pastPartyList) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getUpcominParty(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.upcomingPartyList) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getCurrentParty(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.currentPartyList) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getCountruList(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.countryList) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getStateList(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
           WebRequester.shared.requests(url: Domain.url + EndPoint.stateList, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getMyProfile(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.myProfile, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func editProfile(vc:UIViewController, param: dictionary, postImage: UIImage?, bannerImage: UIImage?, imageName:String?,
                     bannerimageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithImage(url: Domain.url + EndPoint.editProfile, parameter: param, withPostImage: postImage, withPostImageName: imageName, withParamName: "profile_pic",  withBannerImage: bannerImage, withPostImageName: bannerimageName, withbannerParamName: "banner_pic") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getAboutUs(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.aboutUs) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getMyShop(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.myShop, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func deleteProduct(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.deleteProduct, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getFolowerList(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.getFollowerList, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getFollowingList(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.getFollowingList, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func FollowUser(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.FollowUser, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func UnFollowUser(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.UnFollowUser, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getcategory(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.getcategory) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getSize(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.getSize, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getBrand(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.getBrand) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func addMyProduct(vc:UIViewController, param: dictionary, withPostImageAry postImgsAry:[UIImage] = [UIImage](), withPostImageNameAry imgNameAry:[String] = [String](), failer:failureBlock? = nil, success:@escaping successBlock ){
       
        WebRequester.shared.requestsWithImage(url: Domain.url + EndPoint.addProduct, parameter: param, withPostImage: nil, withPostImageName: nil, withPostImageAry: postImgsAry, withPostImageNameAry: imgNameAry, withParamName: "product") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
        
    }
    func addNewParty(vc:UIViewController, param: dictionary, postImage: UIImage?, imageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requestsWithImage(url: Domain.url + EndPoint.addNewParty, parameter: param, withPostImage: postImage, withPostImageName: imageName, withParamName: "profile") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getProductDetail(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.url + EndPoint.getProductDetail, parameter: param) { (result) in
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
extension ModelClass {
    
    private func checkResponce(vc: UIViewController?, result: Result<Any>) -> (isSuccess:Bool, dic:dictionary? ,message:String?) {
        ModelClass.sharedAppdelegate.stoapLoader()
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

