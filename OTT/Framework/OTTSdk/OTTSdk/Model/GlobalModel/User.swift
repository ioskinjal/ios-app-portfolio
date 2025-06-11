//
//  User.swift
//  YuppTV
//
//  Created by Muzaffar on 05/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit


public class User: YuppModel, NSCoding {

    public var name = ""
    public var languages = ""
    public var phoneNumber = ""
    public var email = ""
    public var isEmailVerified = false
    public var status = -1
    public var message = ""
    public var userId = -1
    public var isPhoneNumberVerified = false
    public var packages = [Any]()
    public var rawData = [String : Any]()
    public var attributes = Attributes()
    public var firstName = ""
    public var lastName = ""
    public var dob = NSNumber()
    public var gender = ""
    public var profileParentalDetails = [ProfileParentalDetails]()
    public var profileId = -1
    public var sessionDetails = SessionDetails()
    internal override init() {
        super.init()
    }
    
    internal init(withJson response: [String : Any]) {
        
        super.init()
        rawData = response
        profileId = getInt(value: response["profileId"])
        name = getString(value: response["name"])
        languages = getString(value: response["languages"])
        phoneNumber = getString(value: response["phoneNumber"])
        email = getString(value: response["email"])
        isEmailVerified = getBool(value: response["isEmailVerified"])
        status = getInt(value: response["status"])
        message = getString(value: response["message"])
        userId = getInt(value: response["userId"])
        isPhoneNumberVerified = getBool(value: response["isPhoneNumberVerified"])
        if let attr = response["attributes"] as? [String : Any] {
            attributes = Attributes.init(withJson: attr)
        }
        if let _sessionDetails = response["sessionDetails"] as? [String : Any] {
            sessionDetails = SessionDetails.init(withJson: _sessionDetails)
        }
        dob = getNSNumber(value: response["dob"])

        if let _packages = response["packages"] as? [Any]{
            packages = _packages
        }
        if let _firstName = response["firstName"] as? String{
            firstName = _firstName
        }
        if let _lastName = response["lastName"] as? String{
            lastName = _lastName
        }
        gender = response["gender"] as? String ?? ""
        if let profile = response["profileParentalDetails"] as? [[String : Any]] {
            for json in profile {
                profileParentalDetails.append(ProfileParentalDetails.init(withJson: json))
            }
        }
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        }
        if let languages = aDecoder.decodeObject(forKey: "languages") as? String {
            self.languages = languages
        }
        
        if let mobile = aDecoder.decodeObject(forKey: "phoneNumber") as? String {
            self.phoneNumber = mobile
        }
        
        if let email = aDecoder.decodeObject(forKey: "email") as? String {
            self.email = email
        }

        self.isEmailVerified = aDecoder.decodeBool(forKey: "isEmailVerified")

        self.status = aDecoder.decodeInteger(forKey: "status")

        if let message = aDecoder.decodeObject(forKey: "message") as? String {
            self.message = message
        }
        
        self.userId = aDecoder.decodeInteger(forKey: "userId")
        self.isPhoneNumberVerified = aDecoder.decodeBool(forKey: "isPhoneNumberVerified")


        
        if let packages = aDecoder.decodeObject(forKey: "packages") as? [Any] {
            self.packages = packages
        }
        
        if let _attributes = aDecoder.decodeObject(forKey: "attributes") as? Attributes {
            self.attributes = _attributes
        }

        if let _rawData = aDecoder.decodeObject(forKey: "rawData") as? [String : Any] {
            self.rawData = _rawData
        }
        if let _firstName = aDecoder.decodeObject(forKey: "firstName") as? String{
            self.firstName = _firstName
        }
        if let _lastName = aDecoder.decodeObject(forKey: "lastName") as? String{
            self.lastName = _lastName
        }
        if let _dob = aDecoder.decodeObject(forKey: "dob") as? NSNumber{
            self.dob = _dob
        }
        self.profileId = aDecoder.decodeInteger(forKey: "profileId")
        if let _profileParentalDetails = aDecoder.decodeObject(forKey: "profileParentalDetails") as? [ProfileParentalDetails] {
            self.profileParentalDetails = _profileParentalDetails
        }
        gender = aDecoder.decodeObject(forKey: "gender") as? String ?? ""
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(languages, forKey: "languages")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(isEmailVerified, forKey: "isEmailVerified")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(isPhoneNumberVerified, forKey: "isPhoneNumberVerified")
        aCoder.encode(packages, forKey: "packages")
        aCoder.encode(attributes, forKey: "attributes")
        aCoder.encode(rawData, forKey: "rawData")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(profileParentalDetails, forKey: "profileParentalDetails")
        aCoder.encode(profileId, forKey: "profileId")
    }
    
    public override var description: String{
        return "name : \(name)" + "\n" + "email : \(email)" + "\n" + "mobile : \(phoneNumber)" + "\n" + "userId : \(userId)"
    }
}
public class ProfileParentalDetails : YuppModel, NSCoding {
    public var profileId = 0
    public var name = ""
    public var isChildren = false
    public var profileRating = ""
    public var addProfilePinEnable = false
    public var langs = ""
    public var isProfileLockActive = false
    public var isMasterProfile = false
    public var isPinAvailable = false
    public var isParentalControlEnabled = false
    public var profileRatingDesc = ""
    public var profileRatingId = 0

    internal override init() {
        super.init()
    }
    
    internal init(withJson response: [String : Any]) {
        
        super.init()
        profileId = getInt(value: response["profileId"])
        name = getString(value: response["name"])
        isChildren = getBool(value: response["isChildren"])
        profileRating = getString(value: response["profileRating"])
        addProfilePinEnable = getBool(value: response["addProfilePinEnable"])
        langs = getString(value: response["langs"])
        isProfileLockActive = getBool(value: response["isProfileLockActive"])
        isMasterProfile = getBool(value: response["isMasterProfile"])
        isPinAvailable = getBool(value: response["isPinAvailable"])
        isParentalControlEnabled = getBool(value: response["isParentalControlEnabled"])
        profileRatingDesc = getString(value: response["profileRatingDesc"])
        profileRatingId = getInt(value: response["profileRatingId"])
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(profileId, forKey: "profileId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(isChildren, forKey: "isChildren")
        aCoder.encode(profileRating, forKey: "profileRating")
        aCoder.encode(addProfilePinEnable, forKey: "addProfilePinEnable")
        aCoder.encode(langs, forKey: "langs")
        aCoder.encode(isProfileLockActive, forKey: "isProfileLockActive")
        aCoder.encode(isMasterProfile, forKey: "isMasterProfile")
        aCoder.encode(isPinAvailable, forKey: "isPinAvailable")
        aCoder.encode(isParentalControlEnabled, forKey: "isParentalControlEnabled")
        aCoder.encode(profileRatingDesc, forKey: "profileRatingDesc")
        aCoder.encode(profileRatingId, forKey: "profileRatingId")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.profileId = aDecoder.decodeInteger(forKey: "profileId")
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        }
        self.isChildren = aDecoder.decodeBool(forKey: "isChildren")
        if let profileRating = aDecoder.decodeObject(forKey: "profileRating") as? String {
            self.profileRating = profileRating
        }
        self.addProfilePinEnable = aDecoder.decodeBool(forKey: "addProfilePinEnable")
        if let langs = aDecoder.decodeObject(forKey: "langs") as? String {
            self.langs = langs
        }
        self.isProfileLockActive = aDecoder.decodeBool(forKey: "isProfileLockActive")
        self.isMasterProfile = aDecoder.decodeBool(forKey: "isMasterProfile")
        self.isPinAvailable = aDecoder.decodeBool(forKey: "isPinAvailable")
        self.isParentalControlEnabled = aDecoder.decodeBool(forKey: "isParentalControlEnabled")
        if let profileRatingDesc = aDecoder.decodeObject(forKey: "profileRatingDesc") as? String {
            self.profileRatingDesc = profileRatingDesc
        }
        self.profileRatingId = aDecoder.decodeInteger(forKey: "profileRatingId")
    }
}
public class Attributes: YuppModel, NSCoding {
    
    public var currency = ""
    public var displayLanguage = ""
    public var timezone = ""
    public var grade = ""
    public var board = ""
    public var email_id = ""
    public var email_notification = ""
    public var iit_jee_neet_application_no = ""
    public var selected_lang_codes = ""
    public var targeted_exam = ""
    public var lms_user_id = ""
    public var lms_user_name = ""
    public var lms_password = ""

    internal override init() {
        super.init()
    }
    
    internal init(withJson response: [String : Any]) {
        
        super.init()
        currency = getString(value: response["currency"])
        displayLanguage = getString(value: response["displayLanguage"])
        timezone = getString(value: response["timezone"])
        grade = getString(value: response["grade"])
        board = getString(value: response["board"])
        email_id = getString(value: response["email_id"])
        email_notification = getString(value: response["email_notification"])
        iit_jee_neet_application_no = getString(value: response["iit_jee_neet_application_no"])
        selected_lang_codes = getString(value: response["selected_lang_codes"])
        targeted_exam = getString(value: response["targeted_exam"])
        lms_user_id = getString(value: response["lms_user_id"])
        lms_user_name = getString(value: response["lms_user_name"])
        lms_password = getString(value: response["lms_password"])
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(currency, forKey: "currency")
        aCoder.encode(displayLanguage, forKey: "displayLanguage")
        aCoder.encode(timezone, forKey: "timezone")
        aCoder.encode(grade, forKey: "grade")
        aCoder.encode(board, forKey: "board")
        aCoder.encode(email_id, forKey: "email_id")
        aCoder.encode(email_notification, forKey: "email_notification")
        aCoder.encode(iit_jee_neet_application_no, forKey: "iit_jee_neet_application_no")
        aCoder.encode(selected_lang_codes, forKey: "selected_lang_codes")
        aCoder.encode(targeted_exam, forKey: "targeted_exam")
        aCoder.encode(lms_user_id, forKey: "lms_user_id")
        aCoder.encode(lms_user_name, forKey: "lms_user_name")
        aCoder.encode(lms_password, forKey: "lms_password")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let currency = aDecoder.decodeObject(forKey: "currency") as? String {
            self.currency = currency
        }
        if let displayLanguage = aDecoder.decodeObject(forKey: "displayLanguage") as? String {
            self.displayLanguage = displayLanguage
        }
        
        if let timezone = aDecoder.decodeObject(forKey: "timezone") as? String {
            self.timezone = timezone
        }
        if let grade = aDecoder.decodeObject(forKey: "grade") as? String {
            self.grade = grade
        }
        if let board = aDecoder.decodeObject(forKey: "board") as? String {
            self.board = board
        }
        if let email_id = aDecoder.decodeObject(forKey: "email_id") as? String {
            self.email_id = email_id
        }
        if let email_notification = aDecoder.decodeObject(forKey: "email_notification") as? String {
            self.email_notification = email_notification
        }
        if let iit_jee_neet_application_no = aDecoder.decodeObject(forKey: "iit_jee_neet_application_no") as? String {
            self.iit_jee_neet_application_no = iit_jee_neet_application_no
        }
        if let selected_lang_codes = aDecoder.decodeObject(forKey: "selected_lang_codes") as? String {
            self.selected_lang_codes = selected_lang_codes
        }
        if let targeted_exam = aDecoder.decodeObject(forKey: "targeted_exam") as? String {
            self.targeted_exam = targeted_exam
        }
        if let lms_user_id = aDecoder.decodeObject(forKey: "lms_user_id") as? String {
            self.lms_user_id = lms_user_id
        }
        if let lms_user_name = aDecoder.decodeObject(forKey: "lms_user_name") as? String {
            self.lms_user_name = lms_user_name
        }
        if let lms_password = aDecoder.decodeObject(forKey: "lms_password") as? String {
            self.lms_password = lms_password
        }
    }

}

public class UserFormElement: YuppModel {

    public var name = ""
    public var priority = 0
    public var nextForm = ""
    public var isMandatory = true
    public var code = ""
    public var formID = 0
    public var formCode = ""
    public var fieldType = ""
    public var countryCode = ""
    public var info = FormInfo()

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        name = getString(value:json["name"])
        priority = getInt(value: json["priority"])
        nextForm = getString(value:json["nextForm"])
        isMandatory = getBool(value: json["isMandatory"])
        code = getString(value: json["code"])
        formID = getInt(value: json["id"])
        formCode = getString(value: json["formCode"])
        fieldType = getString(value: json["fieldType"])
        countryCode = getString(value: json["countryCode"])
        info = FormInfo.init(json["info"] as! [String : Any])
    }

    public static func formElements(json : Any?) -> [UserFormElement]{
        var list = [UserFormElement]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(UserFormElement(obj))
            }
        }
        return list
    }

}

public class FormInfo: YuppModel {

    public var regex = ""
    public var value = ""

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        regex = getString(value:json["regex"])
        value = getString(value: json["value"])
    }
}

public class SessionDetails: YuppModel, NSCoding {
    
    public var clientAppVersion = ""
    public var loginStatus = false
    public var timezone = ""
    public var boxId = ""
    public var displayLangCode = ""
    public var sessionId = ""
    public var deviceSubtype = ""
    public var deviceId = 7
    public var contentLangCodes = ""
    public var productCode = ""

    internal override init() {
        super.init()
    }
    
    internal init(withJson response: [String : Any]) {
        
        super.init()
        clientAppVersion = getString(value: response["clientAppVersion"])
        loginStatus = getBool(value: response["loginStatus"])
        timezone = getString(value: response["timezone"])
        boxId = getString(value: response["boxId"])
        displayLangCode = getString(value: response["displayLangCode"])
        sessionId = getString(value: response["sessionId"])
        deviceSubtype = getString(value: response["deviceSubtype"])
        contentLangCodes = getString(value: response["contentLangCodes"])
        productCode = getString(value: response["productCode"])
        deviceId = getInt(value: response["deviceId"])
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(clientAppVersion, forKey: "clientAppVersion")
        aCoder.encode(loginStatus, forKey: "loginStatus")
        aCoder.encode(timezone, forKey: "timezone")
        aCoder.encode(boxId, forKey: "boxId")
        aCoder.encode(displayLangCode, forKey: "displayLangCode")
        aCoder.encode(sessionId, forKey: "sessionId")
        aCoder.encode(deviceSubtype, forKey: "deviceSubtype")
        aCoder.encode(contentLangCodes, forKey: "contentLangCodes")
        aCoder.encode(productCode, forKey: "productCode")
        aCoder.encode(deviceId, forKey: "deviceId")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let clientAppVersion = aDecoder.decodeObject(forKey: "clientAppVersion") as? String {
            self.clientAppVersion = clientAppVersion
        }
        if let loginStatus = aDecoder.decodeObject(forKey: "loginStatus") as? Bool {
            self.loginStatus = loginStatus
        }
        
        if let timezone = aDecoder.decodeObject(forKey: "timezone") as? String {
            self.timezone = timezone
        }
        if let boxId = aDecoder.decodeObject(forKey: "boxId") as? String {
            self.boxId = boxId
        }
        if let displayLangCode = aDecoder.decodeObject(forKey: "displayLangCode") as? String {
            self.displayLangCode = displayLangCode
        }
        if let sessionId = aDecoder.decodeObject(forKey: "sessionId") as? String {
            self.sessionId = sessionId
        }
        if let deviceSubtype = aDecoder.decodeObject(forKey: "deviceSubtype") as? String {
            self.deviceSubtype = deviceSubtype
        }
        if let contentLangCodes = aDecoder.decodeObject(forKey: "contentLangCodes") as? String {
            self.contentLangCodes = contentLangCodes
        }
        if let productCode = aDecoder.decodeObject(forKey: "productCode") as? String {
            self.productCode = productCode
        }
        if let deviceId = aDecoder.decodeObject(forKey: "deviceId") as? Int {
            self.deviceId = deviceId
        }
    }

}
