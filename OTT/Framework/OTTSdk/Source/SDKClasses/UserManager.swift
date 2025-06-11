//
//  UserManager.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class UserManager: NSObject {
    
    public enum Context {
        case signIn
        case forgotPassword
    }
    
    public struct PreferenceType  {
        /// Comma separated languages
        public static let languages = "lang"
        
        /// Comma separated genres
        public static let genres = "genres"
        
        /// Comma separated cast
        public static let cast = "cast"
    }

    
    //TODO: - Implement
    internal override init() {
        super.init()
    }
    
    
    /**
     Sign-in with email/mobile and password.
     
     - Parameters:
         - emailOrMobile : email or mobile number without +,-
         - password : valid password (Ex: yupptv@123)
         - onSuccess: signIn successful
             - User: User object
         - onFailure: signIn failed
             - APIError: error object with code and message
     - Returns: void
     */

    public func signIn(emailOrMobile : String,password : String, onSuccess : @escaping (User)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let key = Utility.validateMobile(number: emailOrMobile) ? "mobile" : "email"
        let osVersion = UIDevice.current.systemVersion
        let appVersion = Utility.appVersion()
        let params = key+"="+emailOrMobile+"&password="+password+"&manufacturer="+APIConstants.manufacturer+"&os_version="+osVersion+"&app_version="+appVersion
        API.instance.request(baseUrl: API.url.signIn, parameters: params, methodType: .post, info: nil, logString: "SignIn", onSuccess: { (response) in
            let user = User.init(withJson: response as! [String : Any])
            YuppTVSDK.preferenceManager.user = user
            onSuccess(user)
            
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
    Sign-in with email/mobile and otp.
    
    - Parameters:
        - emailOrMobile : email or mobile number without +,-
        - otp : valid otp sent to email/mobile
        - onSuccess: signIn successful
            - User: User object
        - onFailure: signIn failed
            - APIError: error object with code and message
    - Returns: void
    */

    public func signInWithOTP(emailOrMobile : String,otp : String, onSuccess : @escaping (User)-> Void, onFailure : @escaping(APIError) -> Void){
        let key = Utility.validateMobile(number: emailOrMobile) ? "mobile" : "email"
        
        let params = key+"="+emailOrMobile+"&otp="+otp
        API.instance.request(baseUrl: API.url.signInWithOTP, parameters: params, methodType: .post, info: nil, logString: "SignInWithOTP", onSuccess: { (response) in
            let user = User.init(withJson: response as! [String : Any])
            YuppTVSDK.preferenceManager.user = user
            onSuccess(user)
            
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     send OTP to mobile/email.
     
     - Parameters:
         - emailOrMobile : email or mobile number without +,-
         - contextType : enum - signIn/forgotPassword
         - onSuccess: successful
             - OTP: OTP object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    public func getOTP(emailOrMobile : String,contextType : Context  , onSuccess : @escaping (OTP)-> Void, onFailure : @escaping(APIError) -> Void){
        let key = Utility.validateMobile(number: emailOrMobile) ? "mobile" : "email"
        let context = (contextType == .signIn) ? "logotp" : "fgpwd"
        let params = key+"="+emailOrMobile+"&context="+context
        API.instance.request(baseUrl: API.url.getOTP, parameters: params, methodType: .post, info: nil, logString: "GetOTP", onSuccess: { (response) in
            if let _response = response as? [String : Any]{
                let otp = OTP.init(withJson: _response)
                onSuccess(otp)
            }
            else{
                onFailure(APIError.defaultError())
            }
            
        }) { (error) in
            onFailure(error)
        }
        
    }
    
    /**
     Register new user.
     
     - Parameters:
         - email : Optional, if mobile exist
         - mobile : Optional, if email exist. mobile with CountryCode(Ex:911234512345)
         - password : valid password
         - onSuccess: signup successful
             - User: User object
         - onFailure: signup failed
             - APIError: error object with code and message    
     - Returns: void
     */
    
    public func signUp(email : String, mobile : String,password : String, onSuccess : @escaping (User)-> Void, onFailure : @escaping(APIError) -> Void){
        let osVersion = UIDevice.current.systemVersion
        let appVersion = Utility.appVersion()
        let params = "email="+email+"&mobile="+mobile+"&password="+password+"&manufacturer="+APIConstants.manufacturer+"&os_version="+osVersion+"&app_version="+appVersion
         API.instance.request(baseUrl: API.url.signUp, parameters: params, methodType: .post, info: nil, logString: "SignUp", onSuccess: { (response) in
            let user = User.init(withJson: response as! [String : Any])
            YuppTVSDK.preferenceManager.user = user
            onSuccess(user)
            
         }) { (error) in
            onFailure(error)
        }
        
    }
    
    /**
     This function is to get user information
     
     - Parameters:
         - onSuccess: successful
             - User: User object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func userInfo(onSuccess : @escaping (User)-> Void, onFailure : @escaping(APIError) -> Void){
        API.instance.request(baseUrl: API.url.userInfo, parameters: "", methodType: .get, info: nil, logString: "UserInfo", onSuccess: { (response) in
            let user = User.init(withJson: response as! [String : Any])
            YuppTVSDK.preferenceManager.user = user
            onSuccess(user)

        }) { (error) in
            onFailure(error)
        }
    }
    
    
    /**
     Verify OTP, sent to mobile
     
     - Parameters:
         - mobile: mobile number without +,-
         - otp: valid OTP sent to mobile
         - onSuccess:  successful
             - VerifyOTPResponse: VerifyOTPResponse object
         - onFailure:  failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func verify(mobile : String, otp : String, onSuccess : @escaping (VerifyOTPResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        let params = "mobile="+mobile+"&otp="+otp
        API.instance.request(baseUrl: API.url.verifyMobile, parameters: params, methodType: .post, info: nil, logString: "VerifyMobile", onSuccess: { (response) in
            let _response = VerifyOTPResponse.init(withJson: response as! [String : Any])
            
            //update user data
            self.userInfo(onSuccess: { (success) in onSuccess(_response) }, onFailure: { (error) in onSuccess(_response) })
            
        }) { (error) in
            onFailure(error)
        }
    }
    
    
    
    /**
     Verify OTP, sent to Email
     
     - Parameters:
         - email: valid email
         - otp: valid OTP sent to mobile
         - onSuccess:  successful
             - VerifyOTPResponse: VerifyOTPResponse object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func verify(email : String, otp : String, onSuccess : @escaping (VerifyOTPResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        let params = "email="+email+"&otp="+otp
        API.instance.request(baseUrl: API.url.verifyEmail, parameters: params, methodType: .post, info: nil, logString: "VerifyEmail", onSuccess: { (response) in
            let _response = VerifyOTPResponse.init(withJson: response as! [String : Any])
            onSuccess(_response)
            
            //update user data
            self.userInfo(onSuccess: { (success) in}, onFailure: { (error) in })
            
        }) { (error) in
            onFailure(error)
        }
    }
    
    
    /**
     Update password
     
     - Parameters:
         - currentPassword: Existing Password
         - newPassword: New Password
         - onSuccess: OTP Verified
             - BaseResponse: BaseResponse object
         - onFailure: OTP not verified
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func update(currentPassword : String,newPassword : String, onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        let params = "current_password="+currentPassword+"&new_password="+newPassword
        API.instance.request(baseUrl: API.url.passwordUpdate, parameters: params, methodType: .post, info: nil, logString: "UpdatePassword", onSuccess: { (response) in
            let _response = BaseResponse.init(withResponse: response as! [String : Any])
            onSuccess(_response)
            
        }) { (error) in
            onFailure(error)
        }

    }

    
    /**
     Update password
     
     - Parameters:
         - newMobile: New Mobile Number without +,-. country code should be prefixed
         - onSuccess: Password updated
             - BaseResponse: BaseResponse object
         - onFailure: update failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func update(newMobile : String, onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        let params = "new_mobile="+newMobile
        API.instance.request(baseUrl: API.url.mobileUpdate, parameters: params, methodType: .post, info: nil, logString: "UpdateMobile", onSuccess: { (response) in
            let _response = BaseResponse.init(withResponse: response as! [String : Any])
            
            //update user data
            self.userInfo(onSuccess: { (success) in onSuccess(_response)}, onFailure: { (error) in onSuccess(_response)})
            
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     To update the Billing and shipping address from user profile.
     
     - Parameters:
         - billingAddress: Address
         - shippingAddress: Address
             # Address #
             ````
             Address.init(address1: "Your address1", address2: "Your address2", address3: "Your address3", city: "Your City", state: "Your State", country: "Your Country", zipCode: "123456")
             ````
         - onSuccess: UpdateAddressResponse object
         - onFailure: update failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func update(billingAddress : Address,shippingAddress : Address, onSuccess : @escaping (UpdateAddressResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        let addresses = ["billingAddress":billingAddress.dictionary(),"shippingAddress":shippingAddress.dictionary()]
        API.instance.request(baseUrl: API.url.addressUpdate, parameters: "", methodType: .post, info: ["DICTIONARY":addresses], logString: "UpdateAddress", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(UpdateAddressResponse.init(withJSON: _response))
            
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     To Update the User preferences (selected Languages and Genres)
     to DB.
     
     - Parameters:
         - preference:
             * Raw Data : [PreferenceType : String]
             * Lang, genres and cast are optional
             # Usage #
             ````
             * For language Update
             [ UserManager.PreferenceType.languages:"HIN,TEL" ]
             * For Genres Update
             [ UserManager.PreferenceType.genres:"Action" ]
             * And all in single request
             [ UserManager.PreferenceType.languages:"HIN,TEL", UserManager.PreferenceType.genres:"Action", UserManager.PreferenceType.cast:”vijay,rana”
             ]
             ````
             
         - onSuccess:  BaseResponse object
         - onFailure:  failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func update(preference : [String : String] ,onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        API.instance.request(baseUrl: API.url.preferencesUpdate, parameters: "", methodType: .post, info: ["DICTIONARY":preference], logString: "UpdatePreferences", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            /*
            YuppTVSDK.preferenceManager.updateUserPreferences(preference: nil)
             */
            
            //update user data
            self.userInfo(onSuccess: { (success) in}, onFailure: { (error) in })
            
            onSuccess(BaseResponse.init(withResponse: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
    Forget password & Reset password
    
    - Parameters:
         - email: Optional, if mobile exist
         - mobile: Optional, if email exist. mobile with CountryCode(Ex:91-56675645)
         - password: password
         - otp: OTP
         - onSuccess: Password updated
            - BaseResponse: BaseResponse object
         - onFailure: update failed
            - APIError: error object with code and message
    - Returns: void
    */
    public func forgotPassword(emailOrMobile : String, password : String, otp : String, onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let key = Utility.validateMobile(number: emailOrMobile) ? "mobile" : "email"
        let params = key+"="+emailOrMobile+"&password="+password+"&otp="+otp
        API.instance.request(baseUrl: API.url.forgotPassword, parameters: params, methodType: .post, info: nil, logString: "ForgotPassword", onSuccess: { (response) in
            let _response = BaseResponse.init(withResponse: response as! [String : Any])
            onSuccess(_response)
            
        }) { (error) in
            onFailure(error)
        }
    }
  
    
    /**
     Logout
     
     - Parameters:
         - onSuccess: Password updated
             - BaseResponse: BaseResponse object
         - onFailure: update failed
             - APIError: error object with code and message
     - Returns: void
     */
    public func signOut(onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        API.instance.request(baseUrl: API.url.logOut, parameters: "", methodType: .post, info: nil, logString: "SignOut", onSuccess: { (response) in
            let _response = BaseResponse.init(withResponse: response as! [String : Any])
            YuppTVSDK.preferenceManager.user = nil
            onSuccess(_response)
            
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     User Preferences API : To get the User Preferences like user selected languages and
     genres.
     
     - Parameters:
         - onSuccess:
             - BaseResponse: BaseResponse object
         - onFailure:  failed
             - APIError: error object with code and message
     - Returns: void
     */
    public func preferences(onSuccess : @escaping (Preference)-> Void, onFailure : @escaping(APIError) -> Void){
        API.instance.request(baseUrl: API.url.userPreferences, parameters: "", methodType: .get, info: nil, logString: "Preferences", onSuccess: { (response) in
            let _response = Preference.init(withJson: response as! [String : Any])
            /*
            YuppTVSDK.preferenceManager.updateUserPreferences(preference: _response)
            */
            //update user data
            self.userInfo(onSuccess: { (success) in}, onFailure: { (error) in })
            
            onSuccess(_response)
            
        }) { (error) in
            onFailure(error)
        }
    }
 
    
    /**
     Response contains user account information, addresses and active
     packages of the user.
     
     - Parameters:
         - onSuccess: AccountDetails object
         - onFailure:  failed
             - APIError: error object with code and message
     - Returns: void
     */
    public func accountDetails(onSuccess : @escaping (AccountDetails)-> Void, onFailure : @escaping(APIError) -> Void){
        
        API.instance.request(baseUrl: API.url.userAccountDetails, parameters: "", methodType: .get, info: nil, logString: "AccountDetails", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(AccountDetails.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }

    
    
    /**
     User Transactions API : Response contains transactions that are made recently by the user.
     - Parameters:
         - count : Default = 20
         - lastIndex : Last item index of previous request. used for paging
         - onSuccess: Transactions object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func transactions(count : Int, lastIndex : Int, onSuccess : @escaping (Transactions)-> Void, onFailure : @escaping(APIError) -> Void){
        let params = "count="+String(count)+"&last_index="+String(lastIndex)
        API.instance.request(baseUrl: API.url.transactions, parameters: params, methodType: .get, info: nil, logString: "Transactions", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(Transactions.init(withJson: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    
    /**
     To know user eligible for free trial and to get FT packages.
     - Parameters:
         - onSuccess: FreeTrial list
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func freeTrials(onSuccess : @escaping ([FreeTrial])-> Void, onFailure : @escaping(APIError) -> Void){
        
        API.instance.request(baseUrl: API.url.freetrialList, parameters: "", methodType: .post, info: nil, logString: "FreeTrials", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(FreeTrial.freeTrialList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     Activate-Free trial
     - Parameters:
         - freetrialId: FreeTrial Id
         - onSuccess: ActivateFreeTrialResponse object
             * "message" field in "additionalInfo" object is used whenever nextPage object's name field is
             "dialog".
             ````
             *  .nextPage.name == .dialog //Success
             *  .nextPage.name == .mobileVerification // mobile verification is needed (Verify mobile by using VERIFY-MOBILE API)
             *  .nextPage.name == .emailVerification // Email verification is needed (Verify Email by using VERIFY-Email API)
             ````
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func activateFreeTrial(freetrialId : String , onSuccess : @escaping (ActivateFreeTrialResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        let params = "freetrial_id="+freetrialId
        API.instance.request(baseUrl: API.url.activateFreeTrial, parameters: params, methodType: .post, info: nil, logString: "ActivateFreeTrial", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(ActivateFreeTrialResponse.init(withJson: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    
    /**
     User Linked Devices : To get the User Logged in devices.
     - Parameters:
         - onSuccess: LinkedDevicesResponse list
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func linkedDevices(onSuccess : @escaping ([LinkedDevicesResponse])-> Void, onFailure : @escaping(APIError) -> Void){
        API.instance.request(baseUrl: API.url.linkedDevices, parameters: "", methodType: .get, info: nil, logString: "LinkedDevices", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(LinkedDevicesResponse.devicesList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    
    /**
     Delink-Device
     - Warning :
     ````
     Still needs to update. ( incomplete API documentation as of now )
     This API serves two purposes.
     * Maximum Devices Exceeded case(When user is logging in and not logged in) Logged in user want logout of particular device with box-id and device_type from account page
     * In second case(user logged in) it expects box_id and device_type as form fields to logout user from a particular device.
     ````
     
     - Parameters:
         - onSuccess: BaseResponse Object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func delinkDevice(onSuccess : @escaping (BaseResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        API.instance.request(baseUrl: API.url.delinkDevice, parameters: "", methodType: .post, info: nil, logString: "DelinkDevices", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            
            onSuccess(BaseResponse.init(withResponse: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    

    
}
