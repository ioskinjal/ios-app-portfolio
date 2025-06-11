//
//  FacebookLoginManager.swift
//  LevelShoes
//
//  Created by Maa on 17/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import MBProgressHUD


class FacebookSignInManager: NSObject{
    typealias LoginCompletionBlock = (Dictionary<String, AnyObject>?, NSError?) -> Void
    
    //MARK:- Public functions
       class func basicInfoWithCompletionHandler(_ fromViewController:AnyObject, onCompletion: @escaping LoginCompletionBlock) -> Void {

           //Check internet connection if no internet connection then return


           self.getBaicInfoWithCompletionHandler(fromViewController) { (dataDictionary:Dictionary<String, AnyObject>?, error: NSError?) -> Void in
               onCompletion(dataDictionary, error)
           }
       }
       
       class func logoutFromFacebook() {
        LoginManager().logOut()
        AccessToken.current = nil
        Profile.current = nil
       }
       
       //MARK:- Private functions
       class fileprivate func getBaicInfoWithCompletionHandler(_ fromViewController:AnyObject, onCompletion: @escaping LoginCompletionBlock) -> Void {
           let permissionDictionary = [
               "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)",
               //"locale" : "en_US"
           ]
        if AccessToken.current != nil {
            GraphRequest(graphPath: "/me", parameters: permissionDictionary)
                   .start(completionHandler:  { (connection, result, error) in
                       if error == nil {
                           onCompletion(result as? Dictionary<String, AnyObject>, nil)
                       } else {
                           onCompletion(nil, error as NSError?)
                       }

                   })
           
           } else {
            LoginManager().logIn(permissions: ["email", "public_profile", "user_photos"], from: fromViewController as? UIViewController, handler: { (result, error) -> Void in
                   if error != nil {
//                    LoginManager().logOut()
                    logoutFromFacebook()
                       if let error = error as NSError? {
                           let errorDetails = [NSLocalizedDescriptionKey : "Processing Error. Please try again!"]
                           let customError = NSError(domain: "Error!", code: error.code, userInfo: errorDetails)
                           onCompletion(nil, customError)
                       } else {
                           onCompletion(nil, error as NSError?)
                       }
                       
                   } else if (result?.isCancelled)! {
                    logoutFromFacebook()
//                    LoginManager().logOut()
                       let errorDetails = [NSLocalizedDescriptionKey : "Request cancelled!"]
                       let customError = NSError(domain: "Request cancelled!", code: 1001, userInfo: errorDetails)
                       onCompletion(nil, customError)
                   } else {
                    let pictureRequest = GraphRequest(graphPath: "me", parameters: permissionDictionary)
                    let _ = pictureRequest.start(completionHandler: {
                           (connection, result, error) -> Void in
                           
                           if error == nil {
                               onCompletion(result as? Dictionary<String, AnyObject>, nil)
                           } else {
                               onCompletion(nil, error as NSError?)
                           }
                       })
                   }
               })
           }
       }
}
