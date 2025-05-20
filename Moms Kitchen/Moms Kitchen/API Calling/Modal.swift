//
//  Modal.swift
//  APICalling
//
//  Created by Nirav Sapariya.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

enum Domain {
    static let main = "http://momskitchen.ncryptedprojects.com/webservices-nct/"
    
    //    static func getPayPalUrl(amount: String) -> String{
    //        return "\(Domain.main)payment-nct/paypal-button.php?user_id=\(UserData.shared.getUser()!.user_id)&amount=\(amount)"
    //    }
}

enum EndPoint {
    
    static let login = "login.php"
    static let register = "register.php"
    static let forgotPassword = "forgot_password.php"
    static let changepassword = "reset_password.php"
    static let cusineTypes = "get_cuisine_types.php"
    static let MenuList = "get_menu.php"
    static let Profile = "view_profile.php"
    static let editProfile = "edit_profile.php"
    static let notificationSettings = "update_notification_settings.php"
    static let userAddress = "get_user_addresses.php"
    static let logout = "logout.php"
    static let addAddress = "add_address_info.php"
    static let recommendationCuisines = "get_recommended_cuisines.php"
    static let deleteAddress = "delete_address_info.php"
    static let editAddress = "edit_address_info.php"
    static let getAddress = "get_address_info.php"
    static let changeNotificationSetting = "update_notification_settings.php"
    static let addToCart = "add_to_cart.php"
    static let getNotification = "get_notifications.php"
    static let viewAddress = "view_address_info.php"
    static let getcart = "get_cart.php"
    static let deleteCart = "delete_cart_item.php"
    static let placeOrder = "place_order.php"
    static let checkSum = "Paytm_App_Checksum_Kit_PHP-master/generateChecksum.php"
    static let completePayment = "payment_complete.php"
    static let updateCart = "update_cart_item.php"
    static let myOrders = "my_orders.php"
    static let getOrders = "get_order.php"
    static let cancelOrder = "cancel_order.php"
    static let getInfo = "get_static_pages.php"
    static let getInvoice = "get_invoice.php"
    static let resendLink = "email_confirm.php"
    
    
    
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
    
    
    func changePassword(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.changepassword, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    
    func getForgotPassword(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.forgotPassword, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    
    
    func getCusineTypes(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.cusineTypes) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getMenuList(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
       // Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.MenuList) { (result) in
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
    
    
    
    func editProfileImage(vc:UIViewController, postImage: UIImage?,param:dictionary, imageName:String?, failer:failureBlock? = nil, success:@escaping successBlock ){
        
        WebRequester.shared.requestsWithImage(url: Domain.main + EndPoint.editProfile, parameter:param, withPostImage: postImage, withPostImageName: imageName, withParamName: "user_image") { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getNotificationSettings(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.notificationSettings, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }

    func getUserAddress(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        WebRequester.shared.requests(url: Domain.main + EndPoint.userAddress, parameter: param) { (result) in
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
    
    func addNewAddress(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.addAddress, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getrecommendationcuisines(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.recommendationCuisines, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func deleteAddress(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.deleteAddress, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }

    
    func editAddress(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.editAddress, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getAddressDetail(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.getAddress, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func editNotificationSetting(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.changeNotificationSetting, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func addToCart(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.addToCart, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getNotification(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.getNotification, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func viewAddress(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.viewAddress, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getCart(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.getcart, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func deleteCart(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.deleteCart, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func placeOrder(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.placeOrder, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func checkSum(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.checkSum, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func completePayment(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.completePayment, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func updateCart(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.updateCart, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    func getMyOrders(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.myOrders, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getOrders(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.getOrders, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func cancelOrder(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.cancelOrder, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getInfo(vc:UIViewController, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.getInfo) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func getInvoice(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.getInvoice, parameter: param) { (result) in
            let responce = self.checkResponce(vc: vc, result: result)
            if responce.isSuccess {
                success(responce.dic!)
            }
            else {
                failer?(responce.message!)
            }
        }
    }
    
    func resendLink(vc:UIViewController, param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.resendLink, parameter: param) { (result) in
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
  //  param["device_token"] = UserData.shared.deviceToken
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
    
    func loginAuto(param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        //Modal.sharedAppdelegate.startLoader()
        var param = param
        // param["device_type"] = "i"
        //  param["device_token"] = UserData.shared.deviceToken
        WebRequester.shared.requests(url: Domain.main + EndPoint.login, parameter: param) { (result) in
            let responce = self.checkResponce(vc: nil, result: result)
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

    func signUpAuto(param: dictionary, failer:failureBlock? = nil, success:@escaping successBlock ){
        WebRequester.shared.requests(url: Domain.main + EndPoint.register, parameter: param) { (result) in
            let responce = self.checkResponce(vc: nil, result: result)
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

