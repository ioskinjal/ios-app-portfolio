//
//  UserManager.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class UserManager: NSObject {
    
    public enum LoginMode : Int{
        case password = 1
        case otp = 2
        case socialLogin = 5
    }
    
    public enum OtpContext: String{
        case verifyEmail = "verify_email"
        case verifyMobile = "verify_mobile"
        case signin = "login"
        case updatePassword = "update_password"
        case signup = "signup"
        case parentalcontrol = "parentalcontrol"
    }
    
    public enum OtpTargetType: String{
        case mobile = "mobile"
        case email = "email"
    }
    
    /**
     SignIn With SocialAccount
     
     - Parameters:
     - loginId : email or mobile or any other id like fb_token
     - appVersion : Optional. App Version ex: 1.0
     - password : valid Password
     - onSuccess: Success
     ````
     * To access user details use : OTTSdk.preferenceManager.user
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func signInWithSocialAccount(loginId : String ,password : String ,appVersion : String?, login_type:String?, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        socialSignIn(login_id: loginId, login_mode: .socialLogin, login_key: password, app_version: appVersion, login_type: login_type, onSuccess: { (successMessage) in
            onSuccess(successMessage)
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     SignIn With Password
     
     - Parameters:
     - loginId : email or mobile or any other id like fb_token
     - appVersion : Optional. App Version ex: 1.0
     - password : valid Password
     - onSuccess: Success
     ````
     * To access user details use : OTTSdk.preferenceManager.user
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func signInWithPassword(loginId : String ,password : String ,appVersion : String?, isHeaderEnrichment : Bool, onSuccess : @escaping (_ message : String, _ actionCode : Int)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        signIn(login_id: loginId, login_mode: .password, login_key: password, app_version: appVersion, isHeaderEnrichment: isHeaderEnrichment, onSuccess: { (successMessage, actionCode) in
            onSuccess(successMessage, actionCode)
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     - Parameters:
     - loginId : email
     - appVersion : Optional. App Version ex: 1.0
     - password : valid Password
     - onSuccess: Success
     ````
     * To access user details use : OTTSdk.preferenceManager.user
     - message : successfull message
     - onFailure : Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func signInWithEncryption(loginId : String ,password : String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let appVersion = PreferenceManager.clientAppVersion
        let dic = ["app_version": appVersion, "login_id": loginId, "login_key": password, "login_mode": "1", "manufacturer": APIConstants.manufacturer, "os_version": UIDevice.current.systemVersion]
        
        API.instance.requestWithEncryption(dictionary: dic, requestType: "signin", logString: "SignIn", onSuccess:{ (response) in
            let user = User.init(withJson: response)
            OTTSdk.preferenceManager.user = user
            OTTSdk.preferenceManager.selectedLanguages = user.languages
            onSuccess(user.message)
            return
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     SignIn With Otp
     
     - Parameters:
     - loginId : email or mobile or any other id like fb_token
     - appVersion : Optional. App Version ex: 1.0
     - otp : valid otp
     - onSuccess: Success
     ````
     * To access user details use : OTTSdk.preferenceManager.user
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    public func signInWithOtp(loginId : String ,otp : String ,appVersion : String?, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        signIn(login_id: loginId, login_mode: .otp, login_key: otp, app_version: appVersion, isHeaderEnrichment: false, onSuccess: { successMessage, actionCode  in
            onSuccess(successMessage)
        }) { (error) in
            onFailure(error)
        }
    }
    
    
    internal func signIn(login_id : String ,login_mode : LoginMode ,login_key : String? ,app_version : String?, isHeaderEnrichment : Bool, onSuccess : @escaping (_ message : String, _ actionCode : Int)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let osVersion = UIDevice.current.systemVersion
        var info = ["login_id" : login_id ,"login_mode" : login_mode.rawValue,"os_version" : osVersion, "manufacturer" : APIConstants.manufacturer] as [String : Any]
        
        if app_version != nil{
            info["app_version"] = app_version!
        }
        
        if login_key != nil{
            info["login_key"] = login_key!
        }
        if PreferenceManager.appName == .tsat || PreferenceManager.appName == .aastha{
            info["version"] = 1
        }
        info["is_header_enrichment"] = isHeaderEnrichment
        var url = API.url.signin_v1
        if login_mode == .otp {
            url = API.url.signin
        }
        if OTTSdk.preferenceManager.featuresResponse?.systemFeatures.encryptApisList.fields.signin == true{
            info["is_header_enrichment"] = String(isHeaderEnrichment)
            info["login_mode"] = String(login_mode.rawValue)
            
            API.instance.requestWithEncryption(dictionary: info, requestType: "signin", logString: "SignIn", onSuccess:{ (response) in
                if let signInResponse = response as? [String : Any] {
                    let response = SignInValidateInfo.init(withResponse: signInResponse)
                    onSuccess(response.userDetails?.message ?? "", response.actionCode)
                }
//                let user = User.init(withJson: response)
//                OTTSdk.preferenceManager.user = user
//                OTTSdk.preferenceManager.selectedLanguages = user.languages
//                onSuccess(user.message, 1)
                return
            }) { (error) in
                onFailure(error)
            }
        }else{
            API.instance.request(baseUrl: url, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "SignIn", onSuccess: { (response) in
                if let signInResponse = response as? [String : Any] {
                    let response = SignInValidateInfo.init(withResponse: signInResponse)
                    onSuccess(response.userDetails?.message ?? "", response.actionCode)
                }
                //            let user = User.init(withJson: response as! [String : Any])
                //            print(user.attributes.displayLanguage)
                //            OTTSdk.preferenceManager.user = user
                //            OTTSdk.preferenceManager.selectedLanguages = user.languages
                //            onSuccess(user.message, (response as AnyObject).actionCode)
                
                return
            }) { (error) in
                onFailure(error)
                return
            }
        }
    }
    
    internal func socialSignIn(login_id : String ,login_mode : LoginMode ,login_key : String? ,app_version : String?, login_type:String?, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let osVersion = UIDevice.current.systemVersion
        var info = ["login_id" : login_id ,"login_mode" : login_mode.rawValue,"os_version" : osVersion, "manufacturer" : APIConstants.manufacturer] as [String : Any]
        
        if app_version != nil{
            info["app_version"] = app_version!
        }
        
        if login_key != nil{
            info["login_key"] = login_key!
        }
        if login_type != nil{
            info["login_type"] = login_type!
        }
        if OTTSdk.preferenceManager.featuresResponse?.systemFeatures.encryptApisList.fields.signin == true {
            API.instance.requestWithEncryption(dictionary: info, requestType: "social_signin", logString: "SignIn", onSuccess:{ (response) in
                let user = User.init(withJson: response as! [String : Any])
                OTTSdk.preferenceManager.user = user
                OTTSdk.preferenceManager.selectedLanguages = user.languages
                onSuccess(user.message)
                return
            }) { (error) in
                onFailure(error)
            }
        }else {
            API.instance.request(baseUrl: API.url.socialSignin, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "SocialSignIn", onSuccess: { (response) in
                
                let user = User.init(withJson: response as! [String : Any])
                OTTSdk.preferenceManager.user = user
                OTTSdk.preferenceManager.selectedLanguages = user.languages
                onSuccess(user.message)
                
                return
            }) { (error) in
                onFailure(error)
                return
            }
        }
    }
    
    /**
     Signup
     
     ````
     Required parameters: password
     Optional parameters: Either email or mobile is required. remaining all are optional
     
     ````
     
     - Parameters:
     - email : valid Email
     - mobile : mobile number
     - password : valid Password
     - appVersion : App Version
     - referralType : for future use
     - referralId : for future use
     - onSuccess: Success
     ````
     * To access user details use : OTTSdk.preferenceManager.user
     
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func signup(firstName : String?, lastName : String? ,email : String?, mobile : String? ,password : String, appVersion : String? ,referralType : String? ,referralId : String?, isHeaderEnrichment : Bool,socialAccountId : String?,socialAccountType : String?, dob : String?, gender : String?,onSuccess : @escaping (_ response : SignupValidateInfo)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let osVersion = UIDevice.current.systemVersion
        var info = ["password" : password ,"os_version" : osVersion, "manufacturer" : APIConstants.manufacturer] as [String:Any]
        
        if let _firstName = firstName, _firstName.count > 0 {
            info["first_name"] = _firstName
        }
        if let _lastName = lastName, _lastName.count > 0 {
            info["last_name"] = _lastName
        }
        
        var additionalInfo = [String:String]()
        if let _dob = dob, _dob.count > 0 {
            additionalInfo["dob"] = _dob
        }
        if let _gender = gender {
            additionalInfo["gender"] = _gender
        }

        var other_login_Dict = [String:Any]()
        if appVersion != nil{
            info["app_version"] = appVersion!
        }
        if email != nil{
            info["email"] = email!
        }
        if mobile != nil{
            info["mobile"] = mobile!
        }
        if PreferenceManager.appName == .tsat || PreferenceManager.appName == .aastha{
            info["version"] = 1
        }
        if referralType != nil{
            info["referral_type"] = referralType!
        }else {
            info["referral_type"] = ""
        }
        if referralId != nil{
            info["referral_id"] = referralId!
        }else {
            info["referral_id"] = ""
        }
        if socialAccountType == "facebook" {
            other_login_Dict = ["facebook" : socialAccountId ?? ""]
        }
        else if socialAccountType == "google" {
            other_login_Dict = ["google" : socialAccountId ?? ""]
        }
        else if socialAccountType == "apple" {
            other_login_Dict = ["apple" : socialAccountId ?? ""]
        }
        else if socialAccountType == "twitter" {
            other_login_Dict = ["twitter" : socialAccountId ?? ""]
        }
        else {
            other_login_Dict = [:]
        }
        if additionalInfo.count > 0 {
            info["additional_params"] = additionalInfo
        }
        if OTTSdk.preferenceManager.featuresResponse?.systemFeatures.encryptApisList.fields.signup == true {
            let jsonData = try! JSONSerialization.data(withJSONObject: other_login_Dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            info["other_login"] = jsonString
            if additionalInfo.count > 0 {
                let additional_jsonData = try! JSONSerialization.data(withJSONObject: additionalInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
                let additonal_jsonString = NSString(data: additional_jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                info["additional_params"] = additonal_jsonString
            }
        }
        else {
            info["other_login"] = other_login_Dict
        }
        //info["additional_params"] = additionalInfo
        info["is_header_enrichment"] = isHeaderEnrichment
        if OTTSdk.preferenceManager.featuresResponse?.systemFeatures.encryptApisList.fields.signup == true {
            info["is_header_enrichment"] = "false"
            API.instance.requestWithEncryption(dictionary: info, requestType: "signup", logString: "Signup", onSuccess:{ (response) in
                if let signupResponse = response as? [String : Any] {
                    let response = SignupValidateInfo.init(withResponse: signupResponse)
                    onSuccess(response)
                }
//                let user = User.init(withJson: response)
//                OTTSdk.preferenceManager.user = user
//                OTTSdk.preferenceManager.selectedLanguages = user.languages
//                onSuccess(user.message, 1)
                return
            }) { (error) in
                onFailure(error)
            }
        }else{
            API.instance.request(baseUrl: API.url.signup, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "Signup", onSuccess: { (response) in
                if let signupResponse = response as? [String : Any] {
                    let response = SignupValidateInfo.init(withResponse: signupResponse)
                    onSuccess(response)
                }
                return
            }) { (error) in
                onFailure(error)
                return
            }
        }
    }
    
    /**
     Signup
     
     ````
     Required parameters: password
     Optional parameters: Either email or mobile is required. remaining all are optional
     
     ````
     
     - Parameters:
     - email : valid Email
     - mobile : mobile number
     - password : valid Password
     - appVersion : App Version
     - referralType : for future use
     - referralId : for future use
     - onSuccess: Success
     ````
     * To access user details use : OTTSdk.preferenceManager.user
     
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func signupWithOTPVerification(referenceId : String ,otp:Int, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["otp" : otp ,"reference_key" : referenceId] as [String:Any]
        
        API.instance.request(baseUrl: API.url.signupOTPVerification, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "Signup", onSuccess: { (response) in
            
            let user = User.init(withJson: response as! [String : Any])
            OTTSdk.preferenceManager.user = user
            OTTSdk.preferenceManager.selectedLanguages = user.languages
            onSuccess(user.message)
            
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Signup With SocialAccount
     
     ````
     Required parameters: password
     Optional parameters: Either email or mobile is required. remaining all are optional
     
     ````
     
     - Parameters:
     - email : valid Email
     - mobile : mobile number
     - password : valid Password
     - appVersion : App Version
     - referralType : for future use
     - referralId : for future use
     - onSuccess: Success
     ````
     * To access user details use : OTTSdk.preferenceManager.user
     
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func signupWithSocialAccount(email : String? ,userName : String? ,mobile : String? ,password : String ,appVersion : String? ,referralType : String? ,referralId : String?,socialAcntId : String?,socialAcntType : String?,onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let osVersion = UIDevice.current.systemVersion
        var info = ["password" : password ,"os_version" : osVersion, "manufacturer" : APIConstants.manufacturer] as [String:Any]
        
        if appVersion != nil{
            info["app_version"] = appVersion!
        }
        if email != nil{
            info["email"] = email!
        }
        if mobile != nil{
            info["mobile"] = mobile!
        }
        if userName != nil{
            info["userName"] = userName!
        }
        
        if referralType != nil{
            info["referral_type"] = referralType!
        }
        if referralId != nil{
            info["referral_id"] = referralId!
        }
        var other_login_Dict = [String:Any]()

        if socialAcntType == "facebook" {
            other_login_Dict = ["facebook" : socialAcntId ?? ""]
        }
        else if socialAcntType == "google" {
            other_login_Dict = ["google" : socialAcntId ?? ""]
        }
        else if socialAcntType == "apple" {
            other_login_Dict = ["apple" : socialAcntId ?? ""]
        }
        else if socialAcntType == "twitter" {
            other_login_Dict = ["twitter" : socialAcntId ?? ""]
        }
        else {
            other_login_Dict = [:]
        }
        
        
        if OTTSdk.preferenceManager.featuresResponse?.systemFeatures.encryptApisList.fields.signin == true {
            info["is_header_enrichment"] = "false"
            
            if OTTSdk.preferenceManager.featuresResponse?.systemFeatures.encryptApisList.fields.signup == true {
                let jsonData = try! JSONSerialization.data(withJSONObject: other_login_Dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                info["other_login"] = jsonString
            }
            else {
                info["other_login"] = other_login_Dict
            }
            
            
            API.instance.requestWithEncryption(dictionary: info, requestType: "signup", logString: "Signup", onSuccess:{ (response) in
                let user = User.init(withJson: response as! [String : Any])
                OTTSdk.preferenceManager.user = user
                OTTSdk.preferenceManager.selectedLanguages = user.languages
                onSuccess(user.message)
                return
            }) { (error) in
                onFailure(error)
            }
        }else {
            API.instance.request(baseUrl: API.url.socialSignup, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "SocialSignup", onSuccess: { (response) in
                
                let user = User.init(withJson: response as! [String : Any])
                OTTSdk.preferenceManager.user = user
                OTTSdk.preferenceManager.selectedLanguages = user.languages
                onSuccess(user.message)
                
                return
            }) { (error) in
                onFailure(error)
                return
            }
        }
    }
    public func changeMobileOrEmailAddress(newEmail : String?, newMobile : String?, onSuccess : @escaping (_ otp : OTP)-> Void, onFailure : @escaping(_ error : APIError) -> Void) {
        var payload : [String : String] = [:]
        var url = ""
        var logString = ""
        if let number = newMobile {
            url = API.url.updateMobileNumber
            payload["mobile"] = number
            payload["context"] = OtpContext.verifyMobile.rawValue
            logString = "Update Mobile"
        }else if let email = newEmail {
            payload["email"] = email
            payload["context"] = OtpContext.verifyEmail.rawValue
            url = API.url.updateEmailId
            logString = "Update Email"
        }
        API.instance.request(baseUrl: url, parameters: "", methodType: .post, info: ["DICTIONARY" : payload], logString: logString, onSuccess: { (response) in
            guard let object = (response as? [String : Any]) else {
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(OTP.init(object))
        }) { (error) in
            onFailure(error)
        }
    }
    /**
     User Info
     
     - Parameters:
     - onSuccess: Success
     ````
     * To access user details use : OTTSdk.preferenceManager.user
     
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func userInfo(onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        API.instance.request(baseUrl: API.url.userInfo, parameters: "", methodType: .get, info: nil, logString: "UserInfo", onSuccess: { (response) in
            
            let user = User.init(withJson: response as! [String : Any])
            OTTSdk.preferenceManager.user = user
            onSuccess(user.message)
            
            return
        }) { (error) in
            OTTSdk.preferenceManager.user =  nil
            onFailure(error)
            return
        }
    }
    
    
    
    /**
     User Preference update
     
     - Parameters:
     - selectedLanguageCodes : comma separated language codes. Ex: "TEL,TAM,HIN"
     - sendEmailNotification : Email notification
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func updatePreference(selectedLanguageCodes : String,sendEmailNotification : Bool, appVersion:String = "", onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var info = ["selected_lang_codes" : selectedLanguageCodes,"email_notification" : String(sendEmailNotification), "timezone" : TimeZone.current.identifier]
        
        if appVersion.count > 0 {
            info["clientAppVersion"] = appVersion
        }
        //        if OTTSdk.preferenceManager.user != nil{
        API.instance.request(baseUrl: API.url.sessionPreference, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "UpdatePreference", onSuccess: { (response) in
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            OTTSdk.preferenceManager.selectedLanguages = selectedLanguageCodes
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
        //        }
        //        else{
        //            OTTSdk.preferenceManager.localLanguages = selectedLanguageCodes
        //            onSuccess("Languages updated successfully")
        //        }
    }
    
    /**
     Update User Details
     
     - Parameters:
     - first_name : first_name
     - last_name : last_name
     - email_id : email_id
     - grade : grade
     - board : board
     - targeted_exam : targeted_exam
     - email_notification : email_notification
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    public func updateUserDetails(first_name : String?, last_name : String?, email_id : String?, grade : String?, board : String?, targeted_exam : String?, email_notification : Bool?, date_of_birth : String?,iit_jee_neet_application_no: String?, gender : String?, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var info = [String:Any]()
        if let firstName = first_name {
            info["first_name"] = firstName
        }
        if let lastName = last_name {
            info["last_name"] = lastName
        }
        if let emailId = email_id {
            info["email_id"] = emailId
        }
        if let boardName = board {
            info["board"] = boardName
        }
        if let gradeName = grade {
            info["grade"] = gradeName
        }
        if let targetedExam = targeted_exam {
            info["targeted_exam"] = targetedExam
        }
        if let emailNotification = email_notification {
            info["email_notification"] =  String(emailNotification)
        }
        if let dob = date_of_birth {
            info["date_of_birth"] = dob
        }
        if let application_no = iit_jee_neet_application_no {
            info["iit_jee_neet_application_no"] = application_no
        }
        if let _gender = gender {
            info["gender"] = _gender
        }
        API.instance.request(baseUrl: API.url.updatePreference, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "UpdateUserDetails", onSuccess: { (response) in
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    
    /**
     Sign Out
     
     - Parameters:
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func signOut(onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        API.instance.request(baseUrl: API.url.signout, parameters: "", methodType: .post, info: nil, logString: "SignOut", onSuccess: { (response) in
            OTTSdk.preferenceManager.localLanguages = ""
            OTTSdk.preferenceManager.selectedLanguages = ""
            OTTSdk.preferenceManager.user = nil
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            guard let message = (response as? [String : Any])?["message"] as? String else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     GET OTP
     - Parameters:
     - mobile : valid mobile
     - email : valid email
     - context : OtpContext enum
     - onSuccess: Success
     - otp: OTP object
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getOTP(mobile : String?,email : String?,context: OtpContext, onSuccess : @escaping (_ otp : OTP)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var info = ["context" : context.rawValue]
        
        if mobile != nil{
            info["mobile"] = mobile!
        }
        
        if email != nil{
            info["email"] = email!
        }
        
        API.instance.request(baseUrl: API.url.getOtp, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "GetOTP", onSuccess: { (response) in
            guard let _response = (response as? [String : Any]) else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(OTP.init(_response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    
    /**
     USER GET OTP(For logged in user)
     - Parameters:
     - targetType : OtpTargetType enum
     - context : OtpContext enum
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func userGetOtp(targetType : OtpTargetType,context: OtpContext, onSuccess : @escaping (_ otp : OTP)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["target_type" : targetType.rawValue,"context" : context.rawValue]
        
        API.instance.request(baseUrl: API.url.userGetOtp, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "UserGetOtp", onSuccess: { (response) in
            guard let _response = (response as? [String : Any]) else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(OTP.init(_response))
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Resend OTP
     
     - Parameters:
     - referenceId : Long (from get/otp or get/user/otp)
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func resendOTP(referenceId : Int, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["reference_id" : referenceId]
        
        API.instance.request(baseUrl: API.url.resendOtp, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "UserGetOtp", onSuccess: { (response) in
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Create User Profile Lock
     - Parameters:
     - profileId : valid profileId
     - pin : valid pin
     - isParentalControlEnable : true
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func createUsreParentalControlerPinWith(user_id : Int, pin: String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["profileId" : user_id, "pin" : pin, "isParentalControlEnable" : true] as [String : Any]
        API.instance.request(baseUrl: API.url.createParentalPin, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "CreateUsreParentalControler", onSuccess: { (response) in
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    /**
         Update User Profile Lock
         - Parameters:
         - profileId : valid profileId
         - pin : valid pin
         - context : valid context string
         - token : valid token string
         - isParentalControlEnable : true
         - onSuccess: Success
         - message: successfull message
         - onFailure: Unsuccessfull request
         - error : APIError object
         - Returns: Void
         
         */
        
    public func updateUsreParentalControlerPinWith(parameters : [String : Any], onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
            API.instance.request(baseUrl: API.url.updateParentalPin, parameters: "", methodType: .post, info: ["DICTIONARY" : parameters], logString: "UpdateUsreParentalControler", onSuccess: { (response) in
                self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
                guard let message = ((response as? [String : Any])?["message"] as? String) else{
                    onSuccess("")
                    return
                }
                onSuccess(message)
                return
                
            }) { (error) in
                onFailure(error)
                return
            }
        }
    /**
     Validate User Profile Lock
     - Parameters:
     - profileId : valid profileId
     - pin : valid pin
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func validateUsreParentalControlerPinWith(user_id : Int, pin: String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["profileId" : user_id, "pin" : pin] as [String : Any]
        API.instance.request(baseUrl: API.url.createParentalPin, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "ValidateUsreParentalControler", onSuccess: { (response) in
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Authenticate User Password
     - Parameters:
     - context : valid context
     - password : valid password
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func authenticateUsreParentalControlerWith(password : String, context: OtpContext, profileId : Int, onSuccess : @escaping (_ data_response : ParentalPinResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["context" : context.rawValue, "password" : password] as [String : Any]
        API.instance.request(baseUrl: API.url.authenticatePassword, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "Authenticate User Password", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let reset_pin_response = ParentalPinResponse(_response)
            onSuccess(reset_pin_response)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    /**
     Verify Email
     - Parameters:
     - email : valid email
     - otp : valid otp
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func verifyEmail(email : String,otp: Int, context: OtpContext, targetType : String, target : String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var info = ["new_identifier" : email, "otp" : otp, "context" : context.rawValue] as [String : Any]
        if PreferenceManager.appName == .reeldrama {
            if targetType == "email" {
                info["email"] = target
            }
            else if targetType == "mobile" {
                info["mobile"] = target
            }
            else {
                info["email"] = email
            }
        }else {
            info["email"] = email
        }
        API.instance.request(baseUrl: API.url.verifyOTP, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "VerifyEmail", onSuccess: { (response) in
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    
    /**
     Verify Mobile
     - Parameters:
     - mobile : valid mobile
     - otp : valid otp
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     */
    
    public func verifyMobile(mobile : String,otp: Int, context: OtpContext, targetType : String, target : String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var info = ["new_identifier" : mobile, "otp" : otp, "context" : context.rawValue] as [String : Any]
        if PreferenceManager.appName == .reeldrama {
            if targetType == "email" {
                info["email"] = target
            }
            else if targetType == "mobile" {
                info["mobile"] = target
            }
            else {
                info["mobile"] = mobile
            }
        }else {
            info["mobile"] = mobile
        }
        API.instance.request(baseUrl: API.url.verifyOTP, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "VerifyMobile", onSuccess: { (response) in
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    
    /**
     Update password
     
     Either email or mobile is required
     - Parameters:
     - mobile : valid mobile
     - email : valid email
     - password: valid password
     - otp: valid otp
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     */
    
    public func updatePassword(email: String? , mobile : String?, password : String, otp : Int, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var info = ["password" : password,"otp" : otp] as [String : Any]
        if email != nil{
            info["email"] = email!
        }
        if mobile != nil{
            info["mobile"] = mobile!
        }
        
        API.instance.request(baseUrl: API.url.updatePassword, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "Updatepassword", onSuccess: { (response) in
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Change password
     
     - Parameters:
     - oldPassword : valid password
     - newPassword : new Password
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func changePassword(oldPassword: String , newPassword : String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["oldPassword" : oldPassword,"newPassword" : newPassword]
        
        API.instance.request(baseUrl: API.url.changePassword, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "Updatepassword", onSuccess: { (response) in
            self.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Linked Device List
     
     - Parameters:
     - onSuccess: Success
     - devices: Device array
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func linkedDeviceList(onSuccess : @escaping (_ devices : [Device])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        API.instance.request(baseUrl: API.url.linkedDevicesList, parameters: "", methodType: .get, info: nil, logString: "LinkedDeviceList", onSuccess: { (response) in
            
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(Device.array(json: _response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    
    
    /**
     Delink Device
     
     - Parameters:
     - boxId :
     - deviceType :
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func delinkDevice(boxId: String , deviceType : Int, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["box_id" : boxId,"device_type" : deviceType] as [String : Any]
        
        API.instance.request(baseUrl: API.url.delinkDevice, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "DelinkDevice", onSuccess: { (response) in
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    
    /**
     User Active Packages
     
     - Parameters:
     - onSuccess: Success
     - packages: Package array
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func activePackages(onSuccess : @escaping (_ packages : [Package])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        
        API.instance.request(baseUrl: API.url.activePackages, parameters: "", methodType: .get, info: nil, logString: "ActivePackages", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onSuccess([Package]())
                return
            }
            onSuccess(Package.array(json: _response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    
    /**
     Transaction History
     
     - Parameters:
     - page : Page Number
     - count : nil or count
     - onSuccess: Success
     - transactions: Transaction array
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func transactionHistory(page : Int,count : Int?, onSuccess : @escaping (_ transactions : [Transaction])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        var params = "page=" + String(page)
        if let _count = count{
            params = params + "&count=" + String(_count)
        }
        API.instance.request(baseUrl: API.url.transactionHistory, parameters: params, methodType: .get, info: nil, logString: "TransactionHistory", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onSuccess([Transaction]())
                return
            }
            onSuccess(Transaction.array(json: _response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }

    
    
    /**
     Session Preference
     
     - Parameters:
     - displayLangCode: Display code from Config response
     - onSuccess: Success
     - message : Success Message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func sessionPreference(displayLangCode: String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["display_lang_code" : displayLangCode]
        
        API.instance.request(baseUrl: API.url.sessionPreference, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "SessionPreference", onSuccess: { (response) in
            OTTSdk.preferenceManager.selectedDisplayLanguage = displayLangCode
            
            // config nill to get menu in selected language
            ConfigResponse.StoredConfig.lastUpdated = nil
            ConfigResponse.StoredConfig.response = nil
            
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Get User Favourites
     
     - Parameters:
     - onSuccess: Success
     ````
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getUserFavouritesList(onSuccess : @escaping (_ response : [SectionData])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        API.instance.request(baseUrl: API.url.userFavourites, parameters: "", methodType: .get, info: nil, logString: "GetUserFavourites", onSuccess: { (response) in
            
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SectionData.sectionsDataList(json: _response))
            
            return
        }) { (error) in
            OTTSdk.preferenceManager.user =  nil
            onFailure(error)
            return
        }
    }
    
    /**
     Add User Favourite item
     
     - Parameters:
     - pagePath:String
     - onSuccess: Success
     ````
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func AddUserFavouriteItem(pagePath:String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "path=\(pagePath)&action=\(1)"
        API.instance.request(baseUrl: API.url.userFavouriteItem, parameters: params, methodType: .get, info: nil, logString: "AddUserFavouriteItem", onSuccess: { (response) in
            
            guard let message = (response as? [String : Any])?["message"] as? String else{
                onSuccess("")
                return
            }
            onSuccess(message)
            
            return
        }) { (error) in
            //OTTSdk.preferenceManager.user =  nil
            onFailure(error)
            return
        }
    }
    
    /**
     Add User Favourite item
     
     - Parameters:
     - pagePath:String
     - onSuccess: Success
     ````
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func deleteUserFavouriteItem(pagePath:String, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "path=\(pagePath)&action=\(2)"
        API.instance.request(baseUrl: API.url.userFavouriteItem, parameters: params, methodType: .get, info: nil, logString: "deleteUserFavouriteItem", onSuccess: { (response) in
            
            guard let message = (response as? [String : Any])?["message"] as? String else{
                onSuccess("")
                return
            }
            onSuccess(message)
            
            return
        }) { (error) in
            //OTTSdk.preferenceManager.user =  nil
            onFailure(error)
            return
        }
    }
    
    /**
     Verify OTP for Forgot Password
     - Parameters:
     - userIndentifier : user email or mobile
     - otp : valid otp
     - onSuccess: Success
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     */
    
    public func verifyOTPForForgotPassward(userIndentifier : String, userType : String, otp: Int, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let info = ["identifier" : userIndentifier, "identifierType" : userType, "otp" : otp] as [String : Any]
        
        API.instance.request(baseUrl: API.url.verifyOTP, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "VerifyOTP", onSuccess: { (response) in
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Submit Question
     
     - Parameters:
     - question : user question
     - path : content path
     - userName : user id
     - onSuccess: Success
     ````
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func submitQuestion(question : String ,path : String ,userName : String, fileData:NSData?, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var info = ["question" : question ,"path" : path,"username" : userName] as [String : Any]
        if let fileContent = fileData {
            info["attached-file"] = fileContent as Data
            info["file_format"] = "png"
        }
        
        
        API.instance.request(baseUrl: API.url.submitQuestion, parameters: "", methodType: .post, info: ["DICTIONARY" : info], logString: "Submit Question", onSuccess: { (response) in
            
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Fetch Questions
     
     - Parameters:
     - path : content path
     - onSuccess: Success
     ````
     - questions: List of questions
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func fetchQuestions(path : String , onSuccess : @escaping (_ questions : [Question])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "path=" + path
        
        API.instance.request(baseUrl: API.url.fetchQuestions, parameters: params, methodType: .get, info: nil, logString: "Fetch Questions", onSuccess: { (response) in
            
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(Question.questions(json: _response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Get User Form Elements
     
     - Parameters:
     - onSuccess: Success
     ````
     - questions: List of Form Elements
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getUserFormElements(onSuccess : @escaping (_ questions : [UserFormElement])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "form_code=user_details"
        
        API.instance.request(baseUrl: API.url.getUserFormElemets, parameters: params, methodType: .get, info: nil, logString: "Get User Form Elements", onSuccess: { (response) in
            
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(UserFormElement.formElements(json: _response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Get Next User Form Elements
     
     - Parameters:
     - path : group_code
     - onSuccess: Success
     ````
     - questions: List of Form Elements
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getNextUserFormElements(form_code : String, group_code:String ,onSuccess : @escaping (_ questions : [UserFormElement])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        var params = "form_code=" + form_code
        params = params + "&group_code=" + group_code
        
        API.instance.request(baseUrl: API.url.getUserFormElemets, parameters: params, methodType: .get, info: nil, logString: "Get Next User Form Elements", onSuccess: { (response) in
            
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(UserFormElement.formElements(json: _response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Get genres list in my questions
     
     - Parameters:
     - onSuccess: Success
     ````
     - Genres: List of Genres
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getMyQuestionsGenresList(onSuccess : @escaping (_ genres : QuestionGenresResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        API.instance.request(baseUrl: API.url.myQuestionsGenresList, parameters: "", methodType: .get, info: nil, logString: "Get My questions genres list", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(QuestionGenresResponse.init(_response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Get genres content list in my questions
     
     - Parameters:
     - onSuccess: Success
     ````
     - GenresContent: List of Genres content
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getMyQuestionsGenresContentList(genre_code : String,onSuccess : @escaping (_ genres : QuestionGenresContentResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        var params = "content_type=" + "epg"
        params = params + "&genre=" + genre_code

        API.instance.request(baseUrl: API.url.myQuestionsGenresContentList, parameters: params, methodType: .get, info: nil, logString: "Get My questions genres content list", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(QuestionGenresContentResponse.init(_response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Get list in my questions
     
     - Parameters:
     - onSuccess: Success
     ````
     - MyQuestions: List of my questions
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func getMyQuestionsList(genre_code : String,content_id : Int,onSuccess : @escaping (_ genres : MyQuestionsResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var params = "content_type=" + "epg"
        params = params + "&genre=" + genre_code
        params = params + "&content_id=" + String(describing: content_id)

        API.instance.request(baseUrl: API.url.myQuestionsList, parameters: params, methodType: .get, info: nil, logString: "Get My questions list", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(MyQuestionsResponse.init(_response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    /**
     Post User Consent Request
     
     - Parameters:
         - UserId: Display code from Config response
         - onSuccess: Success
         - message : Success Message
         - onFailure: Unsuccessfull request
         - error : APIError object
     
     RES_S_CONSENT_ACCEPTED - If consent accepted.
     RES_S_ERROR_CONSENT_NOT_ACCEPTED - If consent not accepted.
     RES_S_CONSENT_NOT_REQUIRED - If consent not required.(If in case of countrybased)
     RES_S_CONSENT_SUCCESS - If consent successfully inserted or added to user.
     RES_S_ERROR_CONSENT_FAILED - If consent failed updation
     RES_S_UPDATED_SUCCESSFULLY - For profile succesfull updation
     RES_S_ERROR_FAILED_TO_UPDATE - For update profile failed
     RES_S_ERROR_USER_NOT_FOUND - For user not found.
     - Returns: Void
     
     */
    
    public func userConsentRequest(userId: Int, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "user_id=\(userId)"
        
        API.instance.request(baseUrl: API.url.userConsentRequest, parameters: params, methodType: .post, info: nil, logString: "ConsentRequest", onSuccess: { (response) in
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    /**
     Get user cosent status
     
     - Parameters:
     - user_id:Int
     - onSuccess: Success
     ````
     - message: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     */
    
    public func userConsenStatus(userId:Int, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "user_id=\(userId)"
        API.instance.request(baseUrl: API.url.userConsentStatus, parameters: params, methodType: .get, info: nil, logString: "cosentStatus", onSuccess: { (response) in
            
            guard let message = (response as? [String : Any])?["message"] as? String else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
}
