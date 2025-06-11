//
//  FeatureResponse.swift
//  OTTSdktvOS
//
//  Created by Muzaffar Ali on 05/04/21.
//  Copyright © 2021 YuppTV. All rights reserved.
//

import UIKit

public class FeatureResponse: YuppModel {
    
    public var systemFeatures = SystemFeatures()
    
    public init(_ json : [String : Any]){
        super.init()
        if let _systemFeatures = json["systemFeatures"] as? [String : Any]{
            systemFeatures = SystemFeatures.init(_systemFeatures)
        }
    }
}

public class SystemFeatures: YuppModel {
    
    public var otpauthentication = FeatureAndFields()
    public var paymentreminder = FeatureAndFields()
    public var qrcode = FeatureAndFields()
    public var clevertap = FeatureAndFields()
    public var userprofiles = FeatureAndFields()
    public var passcode = FeatureAndFields()
    public var ads = FeatureAndFields()
    public var parentalcontrol : FeatureAndFields!
    public var encryptApisList = FeatureAndFields()
    public var userfields : FeatureAndFields!
    public var globalsettings : FeatureAndFields!
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let _otpauthentication = json["otpauthentication"] as? [String : Any]{
            otpauthentication = FeatureAndFields.init(_otpauthentication)
        }
        if let _paymentreminder = json["paymentreminder"] as? [String : Any]{
            paymentreminder = FeatureAndFields.init(_paymentreminder)
        }
        if let _qrcode = json["qrcode"] as? [String : Any]{
            qrcode = FeatureAndFields.init(_qrcode)
        }
        if let _clevertap = json["clevertap"] as? [String : Any]{
            clevertap = FeatureAndFields.init(_clevertap)
        }
        if let _userprofiles = json["userprofiles"] as? [String : Any]{
            userprofiles = FeatureAndFields.init(_userprofiles)
        }
        if let _passcode = json["passcode"] as? [String : Any]{
            passcode = FeatureAndFields.init(_passcode)
        }
        if let _ads = json["ads"] as? [String : Any]{
            ads = FeatureAndFields.init(_ads)
        }
        if let _parentalcontrol = json["parentalcontrol"] as? [String : Any]{
            parentalcontrol = FeatureAndFields.init(_parentalcontrol)
        }
        if let _encryptApisList = json["encryptApisList"] as? [String : Any]{
            encryptApisList = FeatureAndFields.init(_encryptApisList)
        }
        if let _userfields = json["userfields"] as? [String : Any]{
            userfields = FeatureAndFields.init(_userfields)
        }
        if let _globalsettings = json["globalsettings"] as? [String : Any]{
            globalsettings = FeatureAndFields.init(_globalsettings)
        }
    }
}

public class FeatureAndFields: YuppModel {
    public var feature = Feature();
    public var fields = Fields();
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let _feature = json["feature"] as? [String : Any]{
            feature = Feature.init(_feature)
        }
        if let _fields = json["fields"] as? [String : Any]{
            fields = Fields.init(_fields)
        }
    }
}

public class Feature: YuppModel {
    
    public var featureDescription = "";
    public var code = "";
    public var id = -1;
    public var title = "";
    public var imageUrl = "";
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        featureDescription = getString(value: json["description"])
        code = getString(value: json["code"])
        id = getInt(value: json["id"])
        title = getString(value: json["title"])
        imageUrl = getString(value: json["imageUrl"])
    }
}

public class Fields: YuppModel {
    
    public var verify_otp_for_email_update = false
    public var verify_otp_for_mobile_update = false
    public var otp_verification_order = ""
    public var otp_resend_time = 0
    public var otp_length = 0
    public var verification_type_for_mobile_update = ""
    public var forgot_password_identifier_type = ""
    public var verification_type_for_email_update = ""
    public var max_otp_resend_attempts = 0
    public var default_reminder_mode = ""
    public var exclude_packge_ids = 0
    public var mobile_alert_message = ""
    public var max_profile_limit = 0
    public var length = 0
    public var value = false
    public var consider_grouplist_pg_rating_to_video = false
    public var signin = false
    public var signup = false
    public var payment = false
    public var stream = false
    public var age = -1
    public var gender = -1
    public var isEmailSupported = false
    public var isMobileSupported = false
    public var pin_expiry_duration_in_sec_client = -1
    
    
    public var showFirstName = false
    public var showLastName = false
    public var firstNameCharLimit = -1
    public var lastNameCharLimit = -1
     
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        verify_otp_for_email_update = getBool(value: json["verify_otp_for_email_update"])
        verify_otp_for_mobile_update = getBool(value: json["verify_otp_for_mobile_update"])
        otp_verification_order = getString(value: json["otp_verification_order"])
        otp_resend_time = getInt(value: json["otp_resend_time"])
        otp_length = getInt(value: json["otp_length"])
        verification_type_for_mobile_update = getString(value: json["verification_type_for_mobile_update"])
        forgot_password_identifier_type = getString(value: json["forgot_password_identifier_type"])
        verification_type_for_email_update = getString(value: json["verification_type_for_email_update"])
        max_otp_resend_attempts = getInt(value: json["max_otp_resend_attempts"])
        default_reminder_mode = getString(value: json["default_reminder_mode"])
        exclude_packge_ids = getInt(value: json["exclude_packge_ids"])
        mobile_alert_message = getString(value: json["mobile_alert_message"])
        max_profile_limit = getInt(value: json["max_profile_limit"])
        length = getInt(value: json["length"])
        value = getBool(value: json["value"])
        consider_grouplist_pg_rating_to_video = getBool(value: json["consider_grouplist_pg_rating_to_video"])
        signin = getBool(value: json["signin"])
        signup = getBool(value: json["signup"])
        payment = getBool(value: json["payment"])
        stream = getBool(value: json["stream"])
        age = getInt(value: json["age"])
        gender = getInt(value: json["gender"])
        isEmailSupported = getBool(value: json["isEmailSupported"])
        isMobileSupported = getBool(value: json["isMobileSupported"])
        pin_expiry_duration_in_sec_client = getInt(value: json["pin_expiry_duration_in_sec_client"])
        
        showFirstName = getBool(value: json["showFirstName"])
        showLastName = getBool(value: json["showLastName"])
        firstNameCharLimit = getInt(value: json["firstNameCharLimit"])
        lastNameCharLimit = getInt(value: json["lastNameCharLimit"])
    }
}
public class ParentalPinResponse : YuppModel {
    public var token = ""
    public var message = ""
    public var context = ""
    internal override init() {
        super.init()
    }
    public init(_ json : [String : Any]){
        super.init()
        if let _token = json["token"] as? String {
            token = _token
        }
        if let _message = json["message"] as? String {
            message = _message
        }
        if let _context = json["context"] as? String {
            context = _context
        }
    }
}
