//
//  SignupValidateInfo.swift
//  OTTSdk
//
//  Created by Srikanth on 8/20/20.
//  Copyright © 2020 YuppTV. All rights reserved.
//

import Foundation


public class SignupValidateInfo: YuppModel {
    public internal(set) var actionCode = 0
    public internal(set) var details : SignupValidationDetails?
    public internal(set) var userDetails : User?
    
    public override init() {
        super.init()
    }
    
    init(withResponse response: [String : Any]) {
        super.init()
        actionCode = getInt(value: response["actionCode"])
        if let _details = response["details"] as? [String : Any]{
            details = SignupValidationDetails.init(_details)
        }
        if let _userDetails = response["userDetails"] as? [String : Any]{
            userDetails = User.init(withJson: _userDetails)
            OTTSdk.preferenceManager.user = userDetails!
            OTTSdk.preferenceManager.selectedLanguages = userDetails!.languages
        }
    }
 
    

}
public class SignupValidationDetails: YuppModel {
    
    public var referenceKey = ""
    public var email = ""
    public var mobile = ""
    public var message = ""

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        referenceKey = getString(value: json["referenceKey"])
        email = getString(value: json["email"])
        mobile = getString(value: json["mobile"])
        message = getString(value: json["message"])
    }
}


public class SignInValidateInfo: YuppModel {
    public internal(set) var actionCode = 0
    public internal(set) var userDetails : User?
    
    public override init() {
        super.init()
    }
    
    init(withResponse response: [String : Any]) {
        super.init()
        actionCode = getInt(value: response["actionCode"])
        userDetails = User.init(withJson: response)
        OTTSdk.preferenceManager.user = userDetails!
        OTTSdk.preferenceManager.selectedLanguages = userDetails!.languages
        //            let user = User.init(withJson: response as! [String : Any])
        //            print(user.attributes.displayLanguage)
        //            OTTSdk.preferenceManager.user = user
        //            OTTSdk.preferenceManager.selectedLanguages = user.languages
        //            onSuccess(user.message, (response as AnyObject).actionCode)
    }
 
    

}
