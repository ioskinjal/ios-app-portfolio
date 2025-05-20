//
//  User.swift
//  BooknRide
//
//  Created by NCrypted on 03/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var activationCode = ""
    var countryCode = ""
    var createdDate = ""
    var currenctBalance = ""
    var defaultPaymentMethod = ""
    var depositFund = ""
    var email = ""
    var firstName = ""
    var homeLat = ""
    var homeLocation = ""
    var homeLong = ""
    var isActive = ""
    var isOnline = ""
    var isOpen = ""
    var isUnderRide = ""
    var lastActiveLat = ""
    var lastActiveLong = ""
    var lastLoginDateTime = ""
    var lastName = ""
    var lastRideId = ""
    var login = ""
    var mobileNo = ""
    var onlineWithCarId = ""
    var onlineWithCarTypeId = ""
    var panicCountryCode = ""
    var panicNumber = ""
    var password = ""
    var paypalEmail = ""
    var profileImage = ""
    var redeemRequest = ""
    var register = ""
    var totalPanic = ""
    var uId = ""
    var updatedDate = ""
    var userType = ""
    
    var workLat = ""
    var workLocation = ""
    var workLong = ""
    
    override init() {
        
    }
    
    class func initWithResponse(dictionary:[String:Any]?) -> User {
        guard let dictionary = dictionary else { return User() }
        
        let person = User()
        
        let valid = Validator()
        
        let item = dictionary as NSDictionary
        
        if valid.isNotNull(object: item.object(forKey: "activationCode") as AnyObject){
            person.activationCode = String(format:"%@",item.object(forKey: "activationCode") as! NSString)
            
        }
        
        if valid.isNotNull(object: item.object(forKey: "countryCode") as AnyObject){
            person.countryCode = "\(item.object(forKey: "countryCode") ?? "")"
            
        }
        
        if valid.isNotNull(object: dictionary["createdDate"] as AnyObject){
            person.createdDate = String(format:"%@",item.object(forKey: "createdDate") as! NSString)
            
            
        }
        if valid.isNotNull(object: dictionary["currenctBalance"] as AnyObject){
            person.currenctBalance = String(format:"%@",item.object(forKey: "currenctBalance") as! NSString)
            
            
        }
        if valid.isNotNull(object: dictionary["defaultPaymentMethod"] as AnyObject){
            
            person.defaultPaymentMethod = String(format:"%@",item.object(forKey: "defaultPaymentMethod") as! NSString)
            
            
        }
        if valid.isNotNull(object: dictionary["depositFund"] as AnyObject){
            person.depositFund = String(format:"%@",item.object(forKey: "depositFund") as! NSString)
            
            
        }
        if valid.isNotNull(object: dictionary["email"] as AnyObject){
            person.email = String(format:"%@",item.object(forKey: "email") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["firstName"] as AnyObject){
            person.firstName = String(format:"%@",item.object(forKey: "firstName") as! NSString)
            
            
        }
        if valid.isNotNull(object: dictionary["homeLat"] as AnyObject){
            person.homeLat = String(format:"%@",item.object(forKey: "homeLat") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["homeLocation"] as AnyObject){
            person.homeLocation = String(format:"%@",item.object(forKey: "homeLocation") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["homeLong"] as AnyObject){
            person.homeLong = String(format:"%@",item.object(forKey: "homeLong") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["isActive"] as AnyObject){
            person.isActive = String(format:"%@",item.object(forKey: "isActive") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["isOnline"] as AnyObject){
            person.isOnline = String(format:"%@",item.object(forKey: "isOnline") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["isOpen"] as AnyObject){
            person.isOpen = String(format:"%@",item.object(forKey: "isOpen") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["isUnderRide"] as AnyObject){
            person.isUnderRide = String(format:"%@",item.object(forKey: "isUnderRide") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["lastActiveLat"] as AnyObject){
            person.lastActiveLat = String(format:"%@",item.object(forKey: "lastActiveLat") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["lastActiveLong"] as AnyObject){
            person.lastActiveLong = String(format:"%@",item.object(forKey: "lastActiveLong") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["lastLoginDateTime"] as AnyObject){
            person.lastLoginDateTime = String(format:"%@",item.object(forKey: "lastLoginDateTime") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["lastName"] as AnyObject){
            person.lastName = String(format:"%@",item.object(forKey: "lastName") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["lastRideId"] as AnyObject){
            person.lastRideId = "\(item.object(forKey: "lastRideId") ?? "")"
            
        }
        if valid.isNotNull(object: dictionary["mobileNo"] as AnyObject){
            person.mobileNo = String(format:"%@",item.object(forKey: "mobileNo") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["onlineWithCarId"] as AnyObject){
            person.onlineWithCarId = "\(item.object(forKey: "onlineWithCarId") ?? "")"
            
        }
        if valid.isNotNull(object: dictionary["onlineWithCarTypeId"] as AnyObject){
            person.onlineWithCarTypeId = "\(item.object(forKey: "onlineWithCarTypeId") ?? "")"
            
        }
        if valid.isNotNull(object: dictionary["panicCountryCode"] as AnyObject){
            person.panicCountryCode = String(format:"%@",item.object(forKey: "panicCountryCode") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["panicNumber"] as AnyObject){
            person.panicNumber = String(format:"%@",item.object(forKey: "panicNumber") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["password"] as AnyObject){
            person.password = String(format:"%@",item.object(forKey: "password") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["paypalEmail"] as AnyObject){
            person.paypalEmail = String(format:"%@",item.object(forKey: "paypalEmail") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["profileImage"] as AnyObject){
            person.profileImage = String(format:"%@",item.object(forKey: "profileImage") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["redeemRequest"] as AnyObject){
            person.redeemRequest = String(format:"%@",item.object(forKey: "redeemRequest") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["totalPanic"] as AnyObject){
            person.totalPanic = String(format:"%@",item.object(forKey: "totalPanic") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["uId"] as AnyObject){
            person.uId = "\(item.object(forKey: "uId") ?? "")"
            
        }
        if valid.isNotNull(object: dictionary["updatedDate"] as AnyObject){
            person.updatedDate = String(format:"%@",item.object(forKey: "updatedDate") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["userType"] as AnyObject){
            person.userType = String(format:"%@",item.object(forKey: "userType") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["workLat"] as AnyObject){
            person.workLat = String(format:"%@",item.object(forKey: "workLat") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["workLocation"] as AnyObject){
            person.workLocation = String(format:"%@",item.object(forKey: "workLocation") as! NSString)
            
        }
        if valid.isNotNull(object: dictionary["workLong"] as AnyObject){
            person.workLong = String(format:"%@",item.object(forKey: "workLong") as! NSString)
            
        }
        
        person.register = item.object(forKey: "register") as? String ?? "empty" ?? ""
        person.login = item.object(forKey: "login") as? String ?? ""
        
        return person
        
        
    }
    
    class func saveUser(loggedUser:User){
        
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        
        UserDefaults.standard.set(loggedUser.email, forKey: "\(String(describing: appName))email")
        UserDefaults.standard.set(loggedUser.password, forKey: "\(String(describing: appName))password")
        UserDefaults.standard.set(loggedUser.uId, forKey: "\(String(describing: appName))uId")
        UserDefaults.standard.set(loggedUser.profileImage, forKey: "\(String(describing: appName))profileImage")
        UserDefaults.standard.set(loggedUser.mobileNo, forKey: "\(String(describing: appName))mobileNo")
        UserDefaults.standard.set(loggedUser.lastName, forKey: "\(String(describing: appName))lastName")
        UserDefaults.standard.set(loggedUser.firstName, forKey: "\(String(describing: appName))firstName")
        UserDefaults.standard.synchronize()
        
    }
    
    class func getUser() -> User{
        
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        
        let loggedUser = User()
        
        loggedUser.email = (UserDefaults.standard.object(forKey: "\(String(describing: appName))email") as? String ?? "")!
        loggedUser.password =  (UserDefaults.standard.object(forKey: "\(String(describing: appName))password") as? String ?? "")!
        loggedUser.uId =  (UserDefaults.standard.object(forKey: "\(String(describing: appName))uId") as? String ?? "")!
        loggedUser.profileImage =  (UserDefaults.standard.object(forKey: "\(String(describing: appName))profileImage") as? String ?? "")!
        loggedUser.mobileNo = (UserDefaults.standard.object(forKey: "\(String(describing: appName))mobileNo") as? String ?? "")!
        loggedUser.lastName =  (UserDefaults.standard.object(forKey: "\(String(describing: appName))lastName") as? String ?? "")!
        loggedUser.firstName =  (UserDefaults.standard.object(forKey: "\(String(describing: appName))firstName") as? String ?? "")!
        
        return loggedUser
    }
    
    class func isUserLoggedIn() -> Bool{
        
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        
        var loggedUser: Bool = false
        
        loggedUser = UserDefaults.standard.bool(forKey: "\(String(describing: appName))isLoggedIn")
        
        return loggedUser
    }
    
    class func setUserLoginStatus(isLogin:Bool) {
        
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        
        UserDefaults.standard.set(isLogin, forKey: "\(String(describing: appName))isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
}

class Language:NSObject{
    var id:Int = -1
    var languageName:String =  ""
    var defaultLanguage:String = ""
    
    override init() {
        super.init()
        
    }
    init(data:[String:Any]) {
        self.id = data["id"] as? Int ?? -1
        self.languageName = data["languageName"] as? String ?? ""
        self.defaultLanguage = data["default_lan"] as? String ?? ""
    }
    class func saveLanguage(loggedUser:Language){
        
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        
        UserDefaults.standard.set(loggedUser.id, forKey: "\(String(describing: appName))lanId")
        UserDefaults.standard.set(loggedUser.languageName, forKey: "\(String(describing: appName))lanName")
        UserDefaults.standard.set(loggedUser.defaultLanguage, forKey: "\(String(describing: appName))lanDefault")
        UserDefaults.standard.synchronize()
    }
    
    class func getLanguage() -> Language{
        
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        
        let loggedUser = Language()
        
        loggedUser.id = (UserDefaults.standard.object(forKey: "\(String(describing: appName))lanId") as? Int ?? 0)!
        loggedUser.languageName =  (UserDefaults.standard.object(forKey: "\(String(describing: appName))lanName") as? String ?? "")!
        loggedUser.defaultLanguage =  (UserDefaults.standard.object(forKey: "\(String(describing: appName))lanDefault") as? String ?? "")!
        
        return loggedUser
    }
}

class Document{
    var name:String
    var data:Data
    
    init(name:String,data:Data) {
        self.name = name
        self.data = data
    }
}

class Const{
    var UPLOAD_SELFIE:String
    var UPLOAD_SELFIE_MSG:String
    var MSG_TAKE_PHOTO:String
   var TITLE_SELFEI:String
    var UPLOAD_DOC : String = ""
    var ACCEPT_TERMS : String = ""
    var tITLE_SIGNUP : String = ""
    var tITLE_LOGIN : String
    var lBL_FIRST_NAME : String
    var lBL_LAST_NAME : String
    var lBL_EMAIL : String
    var lBL_PASSWORD : String
    var lBL_REMEMBER_PASSWORD : String
    var lBL_SUBMIT : String
    var rEQ_EMAIL : String
    var vALID_EMAIL : String
    var rEQ_PASSWORD : String
    var rEQ_FIRST_NAME : String
    var rEQ_LAST_NAME : String
    var mSG_EMAIL_EXISTS : String
    var mSG_SUCCESS_REGISTER : String
    var lBL_FORGOT_PASSWORD : String
    var mSG_CONFIRM_EMAIL : String
    var mSG_ACCOUNT_DEACTIVATE : String
    var mSG_SUCCESS_LOGIN : String
    var mSG_INVALID_LOGIN : String
    var mSG_FILL_ALL_VALUES : String
    var rEQ_PASSWORD_MIN : String
    var rEQ_FIELD_MAX_LEN : String
    var tITLE_FORGOT_PASSWORD : String
    var tITLE_RESET_PASSWORD : String
    var mSG_ERR_DB_UPDATE : String
    var mSG_ALREADY_REGISTERED : String
    var rESET_PASSWORD_MSG : String
    var nO_EMAIL_FOUND : String
    var sUC_RESET_PASSWORD : String
    var sOMETHING_WRONG : String
    var rESET_LINK_INVALID : String
    var lBL_NEW_PASSWORD : String
    var lBL_CONFIRM_PASSWORD : String
    var rEQ_PASSWORD_CONFIRM : String
    var pASS_CNFPASS_MATCH : String
    var lBL_COVER_PHOTO : String
    var uPLOAD_CHANNEL : String
    var lOGO : String
    var cROP : String
    var cANCEL : String
    var cLOSE : String
    var iNVALID_DETAILS : String
    var sUC_PROFILE_EDITED : String
    var eRR_PROFILE_EDITED : String
    var sUC_ACCOUNT_DELETED : String
    var eRR_ACCOUNT_DELETED : String
    var sUC_PASSWORD_CHANGED : String
    var oLDPASSWORD_WRONG : String
    var eNTER_NEW_PASSWORD : String
    var sUC_CONTACT_SUBMIT : String
    var sUC_VIDEO_UPLOAD : String
    var aDD_DESCRIPTION : String
    var lBL_SELECT_SUBCATEGORY : String
    var lBL_SELECT_CATEGORY : String
    var lBL_SELECT_FILE : String
    var rEQ_CATEGORY : String
    var rEQ_SUBCATEGORY : String
    var rEQ_DESCRIPTION : String
    var sUC_COMMENT_ADDED : String
    var wATCH_LATER_ADD : String
    var nOT_LOGIN : String
    var uPDATED_NOTIFICATIONS : String
    var pREV_TEXT : String
    var nEXT_TEXT : String
    var rECENTLY_UPLOADED : String
    var fEEDBACK : String
    var rEQ_MESSAGE : String
    var cONTACT_US : String
    var eNTER_UR_QUERY_HERE : String
    var mSG_ALRDY_SUB_TO_NEWSLTR : String
    var mSG_SUCC_SUB_FOR_NEWSLTR : String
    var wELCOME_TO : String
    var tITLE_HOME : String
    var mSG_USER_ALRDY_ACTIVATED : String
    var mSG_EMAIL_VERIFY_SUCC : String
    var mSG_INVALID_ACTV_LINK : String
    var tITLE_REGISTRATION : String
    var tITLE_CONTACT_US : String
    var mSG_REQ_ALL_DETAIL : String
    var tITLE_FEEDBACK : String
    var iMAGE_PREVIEW : String
    var sAVE : String
    var mSG_INVALID_IMAGE : String
    var mSG_PLS_UPLOAD_IMAGE_MORE_THAN_1200 : String
    var mSG_FILE_UPLOAD_FAILED_PLS_TRY_AGAIN : String
    var sEARCH : String
    var aDVERTISE : String
    var pROFILE : String
    var nOTIFICATION : String
    var sETTING : String
    var lOGOUT : String
    var bTN_LOGIN : String
    var hELP : String
    var aBOUT : String
    var tERMS_PRIVACY : String
    var rEQUIRED_CAPCHA : String
    var mSG_INVALID_EMAIL : String
    var mSG_INVALID_PASSWORD : String
    var bTN_DONE : String
    var cREATE_AN_ACCOUNT : String
    var lBL_MOBILE_NO : String
    var bTN_UPLOAD_DOCUMENT : String
    var mSG_INVALID_MOBILE_NO : String
    var tITLE_FINANCIAL_INFO : String
    var tITLE_RIDES : String
    var tITLE_ACCOUNT_SETTINGS : String
    var tITLE_INFO : String
    var lBL_SELECT_CAR : String
    var bTN_OFFLINE : String
    var bTN_ONLINE : String
    var lBL_CHANGE_PASSWORD : String
    var lBL_CHANGE_PAYPAL_EMAIL : String
    var lBL_CHANGE_LANGUAGE : String
    var lBL_NOTIFY_RIDE_CANCEL : String
    var lBL_NOTIFY_RIDE_COMPLETED : String
    var lBL_OLD_PWD : String
    var lBL_NEW_PWD : String
    var lBL_CONFIRM_PWD : String
    var lBL_PAYPAL_EMAIL : String
    var bTN_NOTIFICATION_SETTINGS : String
    var mSG_OLD_PWD : String
    var mSG_NEW_PWD : String
    var mSG_CONFIRM_PWD : String
    var mSG_PAYPAL_EMAIL : String
    var mSG_PWD_NO_MATCH : String
    var bTN_UPDATE_PROFILE : String
    var tITLE_EDIT_PROFILE : String
    var tITLE_COMPLETE_PROFILE : String
    var lBL_MY_CARS : String
    var bTN_ADD_CAR : String
    var lBL_CAR_NAME : String
    var lBL_CAR_NO : String
    var mSG_INVALID_CARNAME : String
    var mSG_INVALID_CARNO : String
    var lBL_SET_DEFAULT : String
    var mSG_DELETE_CAR : String
    var bTN_YES : String
    var bTN_NO : String
    var lBL_FILTER : String
    var lBL_TOTAL_RIDES : String
    var lBL_TOTAL_EARNED : String
    var lBL_TOTAL_COMMISION : String
    var lBL_NET_EARNED : String
    var bTN_GO : String
    var mSG_EXIT_APP : String
    var lBL_IN_TOUCH : String
    var lBL_IN_TOUCH_TAG : String
    var lBL_QUERY : String
    var bTN_SEND : String
    var mSG_LOGOUT : String
    var mSG_LOGOUT_SECOND : String
    var bTN_OK : String
    var lBL_SUCCESS : String
    var lBL_CANCELATION : String
    var lBL_INFO : String
    var aLL : String
    var cOMPLETED : String
    var pENDING : String
    var wAITING : String
    var sTATED : String
    var rEJECTED : String
    var eXPIRED : String
    var lBL_VIEW_DETAILS : String
    var pICK_UP : String
    var dROP_OFF : String
    var tITLE_RIDE_DETAILS : String
    var rATTINGS : String
    var lBL_VIEW_LOCATIONO : String
    var lBL_BASE_FARE : String
    var lBL_EXTRA_KM : String
    var lBL_TIME_TAKEN : String
    var lBL_TOTAL : String
    var lBL_WALLET : String
    var lBL_CASH : String
    var tITLE_TRIP_MAP : String
    var pER_KM : String
    var pER_MIN : String
    var pICK_FROM : String
    var gALLERY : String
    var cAMERA : String
    var bTN_END_RIDE : String
    var bTN_COMPLETE_RIDE : String
    var tITLE_FARE_SUMMERY : String
    var mSG_RIDE_REQ : String
    var bTN_ACCEPT_REQ : String
    var bTN_DENY_REQ : String
    var lBL_CALL : String
    var lBL_MESSAGE : String
    var bTN_START_RIDE : String
    var bTN_CANCEL_RIDE : String
    var mSG_RIDE_DENY : String
    var mSG_LOCATION_NOT_FOUND : String
    var mSG_RIDE_TIMEOUT : String
    var mSG_RIDE_ACC_OTHERONE : String
    var nO_LOC_FOUND : String
    var nINJA : String
    var cOZ_MSG : String
    var rETRY : String
    var lOADING : String
    var lOADING_MSG : String
    var mY_REVIEW : String
    var dESCRIPTION : String
    var rPT_DRIVER : String
    var sUBJECT : String
    var mSG_INVALID_SUBJECT : String
    var mSG_INVALID_DESC : String
    var sELECT_LOC : String
    var hOME_LOC : String
    var wORK_LOC : String
    var pICK_LOC : String
    var dROP_LOC : String
    var fARE_ESTIMATE : String
    var bOOK_N_RIDE : String
    var mSG_INVALID_DROP_LOC : String
    var mINFARE : String
    var pER_KM_CHARGE : String
    var tITLE_RIDE_NOW : String
    var mSG_FETCH_DRIVER : String
    var gET_CAR : String
    var fETCH_DRIVER : String
    var sEAT_BELT : String
    var fUEL : String
    var dRIVER_NO_FOUND : String
    var pAYMENT_METHOD : String
    var wALLET : String
    var cASH : String
    var mYPLACES : String
    var aDD_HOME_LOC : String
    var aDD_WORK_LOC : String
    var sAVELOC : String
    var cHANGE_CONTACT : String
    var cHANGE_SETTINGS : String
    var mSG_INVALID_CONTACT : String
    var nOTIFY_FUND : String
    var nOTIFY_REQUEST : String
    var cURRENT_BAL : String
    var cURRENT_BAL_MSG : String
    var rEDEEM_REQ : String
    var rEDEEM_REQ_MSG : String
    var rEDEEM_HISTORY : String
    var dEPOSIT_FUND : String
    var rED_REQ_HIS : String
    var dATE : String
    var aMOUNT : String
    var aVAILAB_BAL : String
    var fUND_MSG : String
    var hINT_AMOUNT : String
    var aMOUNT_MSG : String
    var rATE_DRIVER : String
    var rIDE_INFO : String
    var tRACK_DRIVER : String
    var cANCEL_TRIP : String
    var tIME_CHARGE : String
    var eSTIMATE_ARRIVAL : String
    var cONTACT : String
    var cAR_NUM : String
    var tRACK_TRIP : String
    var tRIP_MAP : String
    var aDDRESS_NOT_FOUND : String
    var sOMTING_WRONG : String
    var eNTER_LOC : String
    var dELETE_LOC : String
    var cANNOT_OFFLINE : String
    var cAR_SELECT : String
    var aLERT : String
    var nO_CAR_ERRO : String
    var nO_HOME_LOC : String
    var nO_WORK_LOC : String
    var mSG_UPLOAD_DOC : String
    var iNVALID_DOC : String
    var lOGGED_IN_SUCCESSFULL : String
    var aCCOUNT_NOT_ACTIVE : String
    var iNVALID_EMAIL_PWD : String
    var rEGI_SUCCESSFUL : String
    var mOBILE_NUMBER_EXIST : String
    var eMAIL_EXISTS : String
    var nO_RECORD_FOUND : String
    var lOCATION_ADDED_SUCCESSFULLY : String
    var lOCATION_REMOVED_SUCCESSFULLY : String
    var rEDEEM_REQUEST_SUCCESSFULLY : String
    var nOT_SUFFICIENT_BALANCE_WALLET : String
    var uSER_NOT_FOUND : String
    var eNTER_PROPER_EMAIL : String
    var fEEDBACK_ADDED_SUCCESSFULL : String
    var pARTNER_NOT_FOUND : String
    var fUND_DEPOSIT_SUCCESSFUL : String
    var aDD_TRANSACTION_ID : String
    var nO_PAYMENT_STATUS : String
    var pLEASE_ADD_AMOUNT : String
    var pROFILE_UPDATED_SUCCESSFULLY : String
    var pLEASE_UPLOAD_SELFIE : String
    var oNLY_JPG_FILE : String
    var rEPORT_SUBMITTED_SUCCESSFULLY : String
    var pLEASE_ADD_DESC : String
    var pLEASE_ADD_SUBJECT : String
    var sUBCATEGORY_NOT_FOUND : String
    var aLREADY_AT_DROPOFF_LOC : String
    var sELECT_DROPOFF_LOCATION : String
    var pLEASE_SELECT_PROPER_LOCATION : String
    var pLEASE_UPLOAD_DOCUMENTS : String
    var cAR_ADDED_SUCCESSFULLY : String
    var eNTER_CAR_NUMBER : String
    var sELECT_SUB_CAR_TYPE : String
    var sELECT_CAR_TYPE : String
    var sELECT_BRAND : String
    var cAR_NUMBER_ALREADY_EXISTS : String
    var cAR_UPDATED_SUCCESSFULLY : String
    var nO_CAR_FOUND : String
    var sELECT_CAR_SUB_TYPE : String
    var cAR_DELETED_SUCCESSFULLY : String
    var vIEW_PDF : String
    var dOWPDF : String
    var pDF_DONLOADING : String
    var pDF_DOW_SUCCESS : String
    var yOU_ARE_ONLINE : String
    var dRIVER_NOT_FOUND : String
    var rIDE_ACCEPTED_SUCCESSFULLY : String
    var aLREADY_IN_RIDE : String
    var rIDE_ALREADY_ACCEPTED_CANCELLED : String
    var pLEASE_GO_ONLINE : String
    var lOCATION_UPDATED_SUCCESSFULLY : String
    var yOU_ARE_NOW_OFFLINE : String
    var pLEASE_COMPLETE_RIDE : String
    var yOU_ARE_ALREADY_OFFLINE : String
    var cONTACT_DETAILS_SUBMITTED : String
    var pLEASE_ENTER_MOBILE_NO : String
    var pLEASE_ENTER_COUNTRY_CODE : String
    var pLEASE_ENTER_EMAIL_ADDRESS : String
    var nEW_PWD_SENT : String
    var dEVICE_REGISTERED_SUCCESSFULLY : String
    var dEVICE_ALREADY_REGISTER : String
    var dEVICE_TOKEN_NOT_FOUND : String
    var dEVICE_NOT_FOUND : String
    var lOGOUT_SUCCESSFULLY : String
    var oLD_PWD_DIFFERENT_NEW : String
    var rIDE_NOT_FOUND : String
    var rIDE_STARTED_SUCCESSFULLY : String
    var rIDE_REJECTED_SUCCESSFULLY : String
    var rIDE_COMPLETED_SUCCESSFULLY : String
    var rIDE_CANCELLED_SUCCESSFULLY : String
    var cAR_BRAND_NOT_FOUND : String
    var cAR_TYPE_NOT_FOUND : String
    var sUB_CAR_TYPE_NOT_FOUND : String
    var rECORD_UPDATED_SUCCESSFULLY : String
    var rIDE_SET_PANIC : String
    var uNKNOWN_USER_TYPE : String
    var vERIFICATION_MAIL_SENT : String
    var cAN_NOT_FOUND_DETAILS : String
    var aCCOUNT_ACTIVATED : String
    var aCCOUNT_ALREADY_ACTIVATED : String
    var uRL_INVALID : String
    var aMOUNT_DEPOSIT_SUCCESSFULLY : String
    var yOUR_FUND_OF_AMOUNT : String
    var sUBMITTED_SUCCESSFULLY : String
    var mSG_ACTIVATE_ACOOUNT : String
    var aCCO_NOT_ACTIVE : String
    var mSG_RESEND : String
    var rESEND : String
    var gOOGLE_CON_FAIL : String
    var dATE_ERROR : String
    var eRROR : String
    var gPS_ERROR : String
    var iNVALID_REDEEM_AMOUNT : String
    var sELECT_PIC : String
    var iNSUFFI_AMNT : String
    var pDF_NOT_FOUND : String
    var tITLE_SELFEI : String
    var nOTIFY_CHANGE_PAYMENT : String
    var nO_EMAIL_EXIST : String
    var  lBL_SELECT_LANGUAGE:String
    
    //New
    var LBL_ACCEPTED:String
    var TITLE_RIDE_REQUEST:String
    var LBL_LOCATION_SERVICE_DISABLED:String
    var LBL_LOCATION:String
    var MSG_NO_INTERNET:String
    var MSG_NETWORK:String
    var REQ_SOCIAL_EMAIL:String
    var MSG_CATEGORY_NOT_AVAILABLE:String
    
    var MSG_DELETE_DEFAULT_CAR:String
    var MSG_ONLY_CAR:String
    
    var MSG_SELECT_TO_DATE:String
    var MSG_SELECT_FROM_DATE:String
    var MSG_NOT_AVAILABLE:String
     var MSG_CHOOSE_PHOTO:String
    
    init(data: [String:Any]) {
        UPLOAD_SELFIE = data["UPLOAD_SELFIE"] as? String ?? "UploadSelfie"
        UPLOAD_SELFIE_MSG = data["UPLOAD_SELFIE"] as? String ?? "please upload a selfie"
         MSG_CHOOSE_PHOTO = data["MSG_CHOOSE_PHOTO"] as? String ?? "Choose Photo"
        MSG_TAKE_PHOTO = data["MSG_TAKE_PHOTO"] as? String ?? "Take Photo"
        TITLE_SELFEI = data["TITLE_SELFEI"] as? String ?? "Upload selfie from below options and wait for approvement..."
        UPLOAD_DOC = data["UPLOAD_DOC"] as?
            String ?? "please upload documents"
        ACCEPT_TERMS = data["ACCEPT_TERMS"] as?
            String ?? "please accept terms and conditions"
        lBL_SELECT_LANGUAGE = data["LBL_SELECT_LANGUAGE"] as? String ?? "Select language"
        tITLE_SIGNUP = data["TITLE_SIGNUP"] as? String ?? "Signup"
        tITLE_LOGIN = data["TITLE_LOGIN"] as? String ?? "Login"
        lBL_FIRST_NAME = data["LBL_FIRST_NAME"] as? String ?? "First Name"
        lBL_LAST_NAME = data["LBL_LAST_NAME"] as? String ?? "Last Name"
        lBL_EMAIL = data["LBL_EMAIL"] as? String ?? "Email Address"
        lBL_PASSWORD = data["LBL_PASSWORD"] as? String ?? "Password"
        lBL_REMEMBER_PASSWORD = data["LBL_REMEMBER_PASSWORD"] as? String ?? "Remember Password"
        lBL_SUBMIT = data["LBL_SUBMIT"] as? String ?? "Submit"
        rEQ_EMAIL = data["REQ_EMAIL"] as? String ?? "Please enter email"
        vALID_EMAIL = data["VALID_EMAIL"] as? String ?? "Please enter valid email"
        rEQ_PASSWORD = data["REQ_PASSWORD"] as? String ?? "Please enter password"
        rEQ_FIRST_NAME = data["REQ_FIRST_NAME"] as? String ?? "Please enter first name"
        rEQ_LAST_NAME = data["REQ_LAST_NAME"] as? String ?? "Please enter last name"
        mSG_EMAIL_EXISTS = data["MSG_EMAIL_EXISTS"] as? String ?? "Email you have Entered is already exists."
        mSG_SUCCESS_REGISTER = data["MSG_SUCCESS_REGISTER"] as? String ?? "You have successfully signup for this site."
        lBL_FORGOT_PASSWORD = data["LBL_FORGOT_PASSWORD"] as? String ?? "Forgot Password"
        mSG_CONFIRM_EMAIL = data["MSG_CONFIRM_EMAIL"] as? String ?? "Dear user, Please check you email account to confirm"
        mSG_ACCOUNT_DEACTIVATE = data["MSG_ACCOUNT_DEACTIVATE"] as? String ?? "Dear user, Your account is deactivated; Please contact admin to activate your account."
        mSG_SUCCESS_LOGIN = data["MSG_SUCCESS_LOGIN"] as? String ?? "Dear user, You are successfully logged in"
        mSG_INVALID_LOGIN = data["MSG_INVALID_LOGIN"] as? String ?? "Invalid login, username or password not macth"
        mSG_FILL_ALL_VALUES = data["MSG_FILL_ALL_VALUES"] as? String ?? "Please fill all value"
        rEQ_PASSWORD_MIN = data["REQ_PASSWORD_MIN"] as? String ?? "Please enter at least 6 characters"
        rEQ_FIELD_MAX_LEN = data["REQ_FIELD_MAX_LEN"] as? String ?? "Please enter no more than 30 characters"
        tITLE_FORGOT_PASSWORD = data["TITLE_FORGOT_PASSWORD"] as? String ?? "Forgot Password"
        tITLE_RESET_PASSWORD = data["TITLE_RESET_PASSWORD"] as? String ?? "Reset Password"
        mSG_ERR_DB_UPDATE = data["MSG_ERR_DB_UPDATE"] as? String ?? "There seems to be some issue while updating your data to our database. Please contact site Admin."
        mSG_ALREADY_REGISTERED = data["MSG_ALREADY_REGISTERED"] as? String ?? "You are already registered as through your email address. So please signin with your login credentials"
        rESET_PASSWORD_MSG = data["RESET_PASSWORD_MSG"] as? String ?? "We have sent password reset link to your inbox, please check your inbox"
        nO_EMAIL_FOUND = data["NO_EMAIL_FOUND"] as? String ?? "No account associated with the entered email address."
        sUC_RESET_PASSWORD = data["SUC_RESET_PASSWORD"] as? String ?? "You have successfully reset your password, please login to continue"
        sOMETHING_WRONG = data["SOMETHING_WRONG"] as? String ?? "Something went wrong,Please try again"
        rESET_LINK_INVALID = data["RESET_LINK_INVALID"] as? String ?? "Password reset link is  invalid"
        lBL_NEW_PASSWORD = data["LBL_NEW_PASSWORD"] as? String ?? "Enter new password"
        lBL_CONFIRM_PASSWORD = data["LBL_CONFIRM_PASSWORD"] as? String ?? "Enter confirm password"
        rEQ_PASSWORD_CONFIRM = data["REQ_PASSWORD_CONFIRM"] as? String ?? "Please confirm password"
        pASS_CNFPASS_MATCH = data["PASS_CNFPASS_MATCH"] as? String ?? "Password and confirm password must match"
        lBL_COVER_PHOTO = data["LBL_COVER_PHOTO"] as? String ?? "Upload Cover Photo"
        uPLOAD_CHANNEL = data["UPLOAD_CHANNEL"] as? String ?? "Upload Channel"
        lOGO = data["LOGO"] as? String ?? "Logo"
        cROP = data["CROP"] as? String ?? "Crop"
        cANCEL = data["CANCEL"] as? String ?? "Cancellations"
        cLOSE = data["CLOSE"] as? String ?? "Close"
        iNVALID_DETAILS = data["INVALID_DETAILS"] as? String ?? "Invalid details"
        sUC_PROFILE_EDITED = data["SUC_PROFILE_EDITED"] as? String ?? "Profile edited successfully"
        eRR_PROFILE_EDITED = data["ERR_PROFILE_EDITED"] as? String ?? "There seems to be some issue while editing profile"
        sUC_ACCOUNT_DELETED = data["SUC_ACCOUNT_DELETED"] as? String ?? "Account deleted successfully."
        eRR_ACCOUNT_DELETED = data["ERR_ACCOUNT_DELETED"] as? String ?? "There seems to be some issue while deleting account"
        sUC_PASSWORD_CHANGED = data["SUC_PASSWORD_CHANGED"] as? String ?? "Password changed successfully"
        oLDPASSWORD_WRONG = data["OLDPASSWORD_WRONG"] as? String ?? "You have entered incorrect old password"
        eNTER_NEW_PASSWORD = data["ENTER_NEW_PASSWORD"] as? String ?? "Please enter new password"
        sUC_CONTACT_SUBMIT = data["SUC_CONTACT_SUBMIT"] as? String ?? "Message sent successfully, Admin will get back to you soon."
        sUC_VIDEO_UPLOAD = data["SUC_VIDEO_UPLOAD"] as? String ?? "Video uploaded successfully."
        aDD_DESCRIPTION = data["ADD_DESCRIPTION"] as? String ?? "Add Description"
        lBL_SELECT_SUBCATEGORY = data["LBL_SELECT_SUBCATEGORY"] as? String ?? "Select subcategory"
        lBL_SELECT_CATEGORY = data["LBL_SELECT_CATEGORY"] as? String ?? "Select Category"
        lBL_SELECT_FILE = data["LBL_SELECT_FILE"] as? String ?? "Select File"
        rEQ_CATEGORY = data["REQ_CATEGORY"] as? String ?? "Category is required"
        rEQ_SUBCATEGORY = data["REQ_SUBCATEGORY"] as? String ?? "Subcategory is required"
        rEQ_DESCRIPTION = data["REQ_DESCRIPTION"] as? String ?? "Description is required"
        sUC_COMMENT_ADDED = data["SUC_COMMENT_ADDED"] as? String ?? "Comment added successfully"
        wATCH_LATER_ADD = data["WATCH_LATER_ADD"] as? String ?? "Added to watch later list"
        nOT_LOGIN = data["NOT_LOGIN"] as? String ?? "Please login to continue"
        uPDATED_NOTIFICATIONS = data["UPDATED_NOTIFICATIONS"] as? String ?? "Notifications updated successfully"
        pREV_TEXT = data["PREV_TEXT"] as? String ?? "prev"
        nEXT_TEXT = data["NEXT_TEXT"] as? String ?? "next"
        rECENTLY_UPLOADED = data["RECENTLY_UPLOADED"] as? String ?? "Recently Uploaded"
        fEEDBACK = data["FEEDBACK"] as? String ?? "Feedback"
        rEQ_MESSAGE = data["REQ_MESSAGE"] as? String ?? "Please Enter Message"
        cONTACT_US = data["CONTACT_US"] as? String ?? "Contact Us"
        eNTER_UR_QUERY_HERE = data["ENTER_UR_QUERY_HERE"] as? String ?? "Enter your query here"
        mSG_ALRDY_SUB_TO_NEWSLTR = data["MSG_ALRDY_SUB_TO_NEWSLTR"] as? String ?? "Already Subscribed for Newsletter"
        mSG_SUCC_SUB_FOR_NEWSLTR = data["MSG_SUCC_SUB_FOR_NEWSLTR"] as? String ?? "Successfully Subscribed for Newsletter"
        wELCOME_TO = data["WELCOME_TO"] as? String ?? "Welcome to"
        tITLE_HOME = data["TITLE_HOME"] as? String ?? "Home"
        mSG_USER_ALRDY_ACTIVATED = data["MSG_USER_ALRDY_ACTIVATED"] as? String ?? "User is already activated"
        mSG_EMAIL_VERIFY_SUCC = data["MSG_EMAIL_VERIFY_SUCC"] as? String ?? "Email verified Successfully"
        mSG_INVALID_ACTV_LINK = data["MSG_INVALID_ACTV_LINK"] as? String ?? "incorrect activation link"
        tITLE_REGISTRATION = data["TITLE_REGISTRATION"] as? String ?? "Registration"
        tITLE_CONTACT_US = data["TITLE_CONTACT_US"] as? String ?? "Contact Us"
        mSG_REQ_ALL_DETAIL = data["MSG_REQ_ALL_DETAIL"] as? String ?? "Please provide all information"
        tITLE_FEEDBACK = data["TITLE_FEEDBACK"] as? String ?? "Feedback"
        iMAGE_PREVIEW = data["IMAGE_PREVIEW"] as? String ?? "Image Preview"
        sAVE = data["SAVE"] as? String ?? "Save"
        mSG_INVALID_IMAGE = data["MSG_INVALID_IMAGE"] as? String ?? "Invalid Image File"
        mSG_PLS_UPLOAD_IMAGE_MORE_THAN_1200 = data["MSG_PLS_UPLOAD_IMAGE_MORE_THAN_1200"] as? String ?? "Please Upload More than 1200X440 Resolution Image"
        mSG_FILE_UPLOAD_FAILED_PLS_TRY_AGAIN = data["MSG_FILE_UPLOAD_FAILED_PLS_TRY_AGAIN"] as? String ?? "File Upload Failed , Please Try Again Later"
        sEARCH = data["SEARCH"] as? String ?? "Search"
        aDVERTISE = data["ADVERTISE"] as? String ?? "Advertise"
        pROFILE = data["PROFILE"] as? String ?? "My Profile"
        nOTIFICATION = data["NOTIFICATION"] as? String ?? "Notification"
        sETTING = data["SETTING"] as? String ?? "Setting"
        lOGOUT = data["LOGOUT"] as? String ?? "Logout"
        bTN_LOGIN = data["BTN_LOGIN"] as? String ?? "Login"
        hELP = data["HELP"] as? String ?? "Help"
        aBOUT = data["ABOUT"] as? String ?? "About"
        tERMS_PRIVACY = data["TERMS_PRIVACY"] as? String ?? "Terms Privacy"
        rEQUIRED_CAPCHA = data["REQUIRED_CAPCHA"] as? String ?? "please prove that you are not a robot"
        mSG_INVALID_EMAIL = data["MSG_INVALID_EMAIL"] as? String ?? "E-mail can not be empty"
        mSG_INVALID_PASSWORD = data["MSG_INVALID_PASSWORD"] as? String ?? "Password cannot be empty"
        bTN_DONE = data["BTN_DONE"] as? String ?? "Done"
        cREATE_AN_ACCOUNT = data["CREATE_AN_ACCOUNT"] as? String ?? "Create an Account"
        lBL_MOBILE_NO = data["LBL_MOBILE_NO"] as? String ?? "Mobile Number"
        bTN_UPLOAD_DOCUMENT = data["BTN_UPLOAD_DOCUMENT"] as? String ?? "Upload Document"
        mSG_INVALID_MOBILE_NO = data["MSG_INVALID_MOBILE_NO"] as? String ?? "Mobile no. cannot be empty"
        tITLE_FINANCIAL_INFO = data["TITLE_FINANCIAL_INFO"] as? String ?? "Financial Information"
        tITLE_RIDES = data["TITLE_RIDES"] as? String ?? "Rides"
        tITLE_ACCOUNT_SETTINGS = data["TITLE_ACCOUNT_SETTINGS"] as? String ?? "Account Settings"
        tITLE_INFO = data["TITLE_INFO"] as? String ?? "Info"
        lBL_SELECT_CAR = data["LBL_SELECT_CAR"] as? String ?? "Please Select Car"
        bTN_OFFLINE = data["BTN_OFFLINE"] as? String ?? "Go Offline"
        bTN_ONLINE = data["BTN_ONLINE"] as? String ?? "Go Online"
        lBL_CHANGE_PASSWORD = data["LBL_CHANGE_PASSWORD"] as? String ?? "Change Passwod"
        lBL_CHANGE_PAYPAL_EMAIL = data["LBL_CHANGE_PAYPAL_EMAIL"] as? String ?? "Change Paypal Email"
        lBL_CHANGE_LANGUAGE = data["LBL_CHANGE_LANGUAGE"] as? String ?? "Change Language"
        lBL_NOTIFY_RIDE_CANCEL = data["LBL_NOTIFY_RIDE_CANCEL"] as? String ?? "Notify me when ride is canceled"
        lBL_NOTIFY_RIDE_COMPLETED = data["LBL_NOTIFY_RIDE_COMPLETED"] as? String ?? "Notify me when ride is completed"
        lBL_OLD_PWD = data["LBL_OLD_PWD"] as? String ?? "Enter Old Password"
        lBL_NEW_PWD = data["LBL_NEW_PWD"] as? String ?? "Enter New Password"
        lBL_CONFIRM_PWD = data["LBL_CONFIRM_PWD"] as? String ?? "Enter Confirm Password"
        lBL_PAYPAL_EMAIL = data["LBL_PAYPAL_EMAIL"] as? String ?? "Enter Paypal Email"
        bTN_NOTIFICATION_SETTINGS = data["BTN_NOTIFICATION_SETTINGS"] as? String ?? "Save Notification Settings"
        mSG_OLD_PWD = data["MSG_OLD_PWD"] as? String ?? "Please enter old password"
        mSG_NEW_PWD = data["MSG_NEW_PWD"] as? String ?? "Please enter new password"
        mSG_CONFIRM_PWD = data["MSG_CONFIRM_PWD"] as? String ?? "Please enter confirm password"
        mSG_PAYPAL_EMAIL = data["MSG_PAYPAL_EMAIL"] as? String ?? "Please enter paypal email"
        mSG_PWD_NO_MATCH = data["MSG_PWD_NO_MATCH"] as? String ?? "Confirm Password does not match"
        bTN_UPDATE_PROFILE = data["BTN_UPDATE_PROFILE"] as? String ?? "Update Profile"
        tITLE_EDIT_PROFILE = data["TITLE_EDIT_PROFILE"] as? String ?? "Edit Profile"
        tITLE_COMPLETE_PROFILE = data["TITLE_COMPLETE_PROFILE"] as? String ?? "Complete Profile"
        lBL_MY_CARS = data["LBL_MY_CARS"] as? String ?? "My Cars"
        bTN_ADD_CAR = data["BTN_ADD_CAR"] as? String ?? "Add Car"
        lBL_CAR_NAME = data["LBL_CAR_NAME"] as? String ?? "Enter Car Name"
        lBL_CAR_NO = data["LBL_CAR_NO"] as? String ?? "Enter Car Number"
        mSG_INVALID_CARNAME = data["MSG_INVALID_CARNAME"] as? String ?? "Please enter car name"
        mSG_INVALID_CARNO = data["MSG_INVALID_CARNO"] as? String ?? "Please enter car no"
        lBL_SET_DEFAULT = data["LBL_SET_DEFAULT"] as? String ?? "Set as default"
        mSG_DELETE_CAR = data["MSG_DELETE_CAR"] as? String ?? "Are you sure you want to delete this car ?"
        bTN_YES = data["BTN_YES"] as? String ?? "Yes"
        bTN_NO = data["BTN_NO"] as? String ?? "no"
        lBL_FILTER = data["LBL_FILTER"] as? String ?? "Filter"
        lBL_TOTAL_RIDES = data["LBL_TOTAL_RIDES"] as? String ?? "Total Rides"
        lBL_TOTAL_EARNED = data["LBL_TOTAL_EARNED"] as? String ?? "Total Earned"
        lBL_TOTAL_COMMISION = data["LBL_TOTAL_COMMISION"] as? String ?? "Total Commision"
        lBL_NET_EARNED = data["LBL_NET_EARNED"] as? String ?? "Net Earned"
        bTN_GO = data["BTN_GO"] as? String ?? "Go"
        mSG_EXIT_APP = data["MSG_EXIT_APP"] as? String ?? "Do you really want to exit ?"
        lBL_IN_TOUCH = data["LBL_IN_TOUCH"] as? String ?? "Get In Touch!"
        lBL_IN_TOUCH_TAG = data["LBL_IN_TOUCH_TAG"] as? String ?? "Always within your reach"
        lBL_QUERY = data["LBL_QUERY"] as? String ?? "Please enter your query here"
        bTN_SEND = data["BTN_SEND"] as? String ?? "Send"
        mSG_LOGOUT = data["MSG_LOGOUT"] as? String ?? "Are you sure you want to logout ?"
        mSG_LOGOUT_SECOND = data["MSG_LOGOUT_SECOND"] as? String ?? "You cannot logout when you are online"
        bTN_OK = data["BTN_OK"] as? String ?? "OK"
        lBL_SUCCESS = data["LBL_SUCCESS"] as? String ?? "Success"
        lBL_CANCELATION = data["LBL_CANCELATION"] as? String ?? "Cancellations"
        lBL_INFO = data["LBL_INFO"] as? String ?? "Information"
        aLL = data["ALL"] as? String ?? "All"
        cOMPLETED = data["COMPLETED"] as? String ?? "Completed"
        pENDING = data["PENDING"] as? String ?? "Pending"
        wAITING = data["WAITING"] as? String ?? "Waiting"
        sTATED = data["STATED"] as? String ?? "Started"
        rEJECTED = data["REJECTED"] as? String ?? "Rejected"
        eXPIRED = data["EXPIRED"] as? String ?? "Expired"
        lBL_VIEW_DETAILS = data["LBL_VIEW_DETAILS"] as? String ?? "View Details"
        pICK_UP = data["PICK_UP"] as? String ?? "Pick Up"
        dROP_OFF = data["DROP_OFF"] as? String ?? "Drop Off"
        tITLE_RIDE_DETAILS = data["TITLE_RIDE_DETAILS"] as? String ?? "Ride Details"
        rATTINGS = data["RATTINGS"] as? String ?? "Ratings"
        lBL_VIEW_LOCATIONO = data["LBL_VIEW_LOCATIONO"] as? String ?? "View location on Map"
        lBL_BASE_FARE = data["LBL_BASE_FARE"] as? String ?? "base fare"
        lBL_EXTRA_KM = data["LBL_EXTRA_KM"] as? String ?? "Extra Km"
        lBL_TIME_TAKEN = data["LBL_TIME_TAKEN"] as? String ?? "Extra Km"
        lBL_TOTAL = data["LBL_TOTAL"] as? String ?? "Total"
        lBL_WALLET = data["LBL_WALLET"] as? String ?? "by Wallet"
        lBL_CASH = data["LBL_CASH"] as? String ?? "by Cash"
        tITLE_TRIP_MAP = data["TITLE_TRIP_MAP"] as? String ?? "Trip Map"
        pER_KM = data["PER_KM"] as? String ?? "Per Km"
        pER_MIN = data["PER_MIN"] as? String ?? "Per Min"
        pICK_FROM = data["PICK_FROM"] as? String ?? "Pick From"
        gALLERY = data["GALLERY"] as? String ?? "Gallery"
        cAMERA = data["CAMERA"] as? String ?? "Camera"
        bTN_END_RIDE = data["BTN_END_RIDE"] as? String ?? "end ride"
        bTN_COMPLETE_RIDE = data["BTN_COMPLETE_RIDE"] as? String ?? "complete ride"
        tITLE_FARE_SUMMERY = data["TITLE_FARE_SUMMERY"] as? String ?? "Fare Summary"
        mSG_RIDE_REQ = data["MSG_RIDE_REQ"] as? String ?? "You have new ride request"
        bTN_ACCEPT_REQ = data["BTN_ACCEPT_REQ"] as? String ?? "accept request"
        bTN_DENY_REQ = data["BTN_DENY_REQ"] as? String ?? "deny request"
        lBL_CALL = data["LBL_CALL"] as? String ?? "Call"
        lBL_MESSAGE = data["LBL_MESSAGE"] as? String ?? "Message"
        bTN_START_RIDE = data["BTN_START_RIDE"] as? String ?? "start ride"
        bTN_CANCEL_RIDE = data["BTN_CANCEL_RIDE"] as? String ?? "cancel ride"
        mSG_RIDE_DENY = data["MSG_RIDE_DENY"] as? String ?? "Are you sure you want to deny this ride?"
        mSG_LOCATION_NOT_FOUND = data["MSG_LOCATION_NOT_FOUND"] as? String ?? "Location not  available"
        mSG_RIDE_TIMEOUT = data["MSG_RIDE_TIMEOUT"] as? String ?? "Your Time limit is over to accept this ride request"
        mSG_RIDE_ACC_OTHERONE = data["MSG_RIDE_ACC_OTHERONE"] as? String ?? "Ride is already accepted by other one or canceled"
        nO_LOC_FOUND = data["NO_LOC_FOUND"] as? String ?? "No Location Found"
        nINJA = data["NINJA"] as? String ?? "Are you a Ninja?"
        cOZ_MSG = data["COZ_MSG"] as? String ?? "coz we can not find your location."
        rETRY = data["RETRY"] as? String ?? "Retry"
        lOADING = data["LOADING"] as? String ?? "Loading..."
        lOADING_MSG = data["LOADING_MSG"] as? String ?? "Please wait while loading"
        mY_REVIEW = data["MY_REVIEW"] as? String ?? "My Review"
        dESCRIPTION = data["DESCRIPTION"] as? String ?? "Description"
        rPT_DRIVER = data["RPT_DRIVER"] as? String ?? "Report Driver"
        sUBJECT = data["SUBJECT"] as? String ?? "Subject"
        mSG_INVALID_SUBJECT = data["MSG_INVALID_SUBJECT"] as? String ?? "Subject cannot be empty"
        mSG_INVALID_DESC = data["MSG_INVALID_DESC"] as? String ?? "Please enter description"
        sELECT_LOC = data["SELECT_LOC"] as? String ?? "Select Location"
        hOME_LOC = data["HOME_LOC"] as? String ?? "Home Location"
        wORK_LOC = data["WORK_LOC"] as? String ?? "Work Location"
        pICK_LOC = data["PICK_LOC"] as? String ?? "Pick Up Location"
        dROP_LOC = data["DROP_LOC"] as? String ?? "Drop Off Location"
        fARE_ESTIMATE = data["FARE_ESTIMATE"] as? String ?? "Fare Estimate"
        bOOK_N_RIDE = data["BOOK_N_RIDE"] as? String ?? "Book n Ride"
        mSG_INVALID_DROP_LOC = data["MSG_INVALID_DROP_LOC"] as? String ?? "Please choose drop off location"
        mINFARE = data["MINFARE"] as? String ?? "Min Fare"
        pER_KM_CHARGE = data["PER_KM_CHARGE"] as? String ?? "Per Km Charges after"
        tITLE_RIDE_NOW = data["TITLE_RIDE_NOW"] as? String ?? "Ride Now"
        mSG_FETCH_DRIVER = data["MSG_FETCH_DRIVER"] as? String ?? "Please  wait while we are fetching a driver"
        gET_CAR = data["GET_CAR"] as? String ?? "Getting car Ready…"
        fETCH_DRIVER = data["FETCH_DRIVER"] as? String ?? "Fetching Driver..."
        sEAT_BELT = data["SEAT_BELT"] as? String ?? "Seat Belt on!"
        fUEL = data["FUEL"] as? String ?? "Fueling up..."
        dRIVER_NO_FOUND = data["DRIVER_NO_FOUND"] as? String ?? "We did not found any driver in the area. Please try after sometime"
        pAYMENT_METHOD = data["PAYMENT_METHOD"] as? String ?? "Payment Method"
        wALLET = data["WALLET"] as? String ?? "Wallet"
        cASH = data["CASH"] as? String ?? "Cash"
        mYPLACES = data["MYPLACES"] as? String ?? "My Places"
        aDD_HOME_LOC = data["ADD_HOME_LOC"] as? String ?? "Add Home Location"
        aDD_WORK_LOC = data["ADD_WORK_LOC"] as? String ?? "Add Work Location"
        sAVELOC = data["SAVELOC"] as? String ?? "Save Location"
        cHANGE_CONTACT = data["CHANGE_CONTACT"] as? String ?? "Change Panic Contact Details"
        cHANGE_SETTINGS = data["CHANGE_SETTINGS"] as? String ?? "Change Notification Settings"
        mSG_INVALID_CONTACT = data["MSG_INVALID_CONTACT"] as? String ?? "Please enter panic contact number"
        nOTIFY_FUND = data["NOTIFY_FUND"] as? String ?? "Notify me when fund deposited to my account"
        nOTIFY_REQUEST = data["NOTIFY_REQUEST"] as? String ?? "Notify me when my redeem request is accepted or rejected"
        cURRENT_BAL = data["CURRENT_BAL"] as? String ?? "Current Balance"
        cURRENT_BAL_MSG = data["CURRENT_BAL_MSG"] as? String ?? "This amount can be used to book a ride"
        rEDEEM_REQ = data["REDEEM_REQ"] as? String ?? "Redeem Request"
        rEDEEM_REQ_MSG = data["REDEEM_REQ_MSG"] as? String ?? "This amount is the amount you requested to redeem."
        rEDEEM_HISTORY = data["REDEEM_HISTORY"] as? String ?? "View Redeem History"
        dEPOSIT_FUND = data["DEPOSIT_FUND"] as? String ?? "Deposit Fund"
        rED_REQ_HIS = data["RED_REQ_HIS"] as? String ?? "Redeem Request History"
        dATE = data["DATE"] as? String ?? "Date"
        aMOUNT = data["AMOUNT"] as? String ?? "Amount"
        aVAILAB_BAL = data["AVAILAB_BAL"] as? String ?? "Available Balance"
        fUND_MSG = data["FUND_MSG"] as? String ?? "You can add funds to your wallet which can be used later to book ride"
        hINT_AMOUNT = data["HINT_AMOUNT"] as? String ?? "Enter Amount ($)"
        aMOUNT_MSG = data["AMOUNT_MSG"] as? String ?? "Please fill deposit amount"
        rATE_DRIVER = data["RATE_DRIVER"] as? String ?? "Please rate the Driver"
        rIDE_INFO = data["RIDE_INFO"] as? String ?? "Ride Information"
        tRACK_DRIVER = data["TRACK_DRIVER"] as? String ?? "Track Driver"
        cANCEL_TRIP = data["CANCEL_TRIP"] as? String ?? "Cancel Trip"
        tIME_CHARGE = data["TIME_CHARGE"] as? String ?? "Time Charge (Per Min)"
        eSTIMATE_ARRIVAL = data["ESTIMATE_ARRIVAL"] as? String ?? "Estimated Arrival Time"
        cONTACT = data["CONTACT"] as? String ?? "Contact No."
        cAR_NUM = data["CAR_NUM"] as? String ?? "Car No."
        tRACK_TRIP = data["TRACK_TRIP"] as? String ?? "Track Trip"
        tRIP_MAP = data["TRIP_MAP"] as? String ?? "Trip Map"
        aDDRESS_NOT_FOUND = data["ADDRESS_NOT_FOUND"] as? String ?? "Cannot get address from clicked location"
        sOMTING_WRONG = data["SOMTING_WRONG"] as? String ?? "There is something wrong while fetching your data. Please try again"
        eNTER_LOC = data["ENTER_LOC"] as? String ?? "Please enter location to continue"
        dELETE_LOC = data["DELETE_LOC"] as? String ?? "Are you sure you want to delete this location"
        cANNOT_OFFLINE = data["CANNOT_OFFLINE"] as? String ?? "You cannot offline when you are in ride"
        cAR_SELECT = data["CAR_SELECT"] as? String ?? "Please select at least one car to go oline"
        aLERT = data["ALERT"] as? String ?? "Alert"
        nO_CAR_ERRO = data["NO_CAR_ERRO"] as? String ?? "You have not added any car in your profile. Please add one to go online."
        nO_HOME_LOC = data["NO_HOME_LOC"] as? String ?? "No Home Location Set"
        nO_WORK_LOC = data["NO_WORK_LOC"] as? String ?? "No Work Location Set"
        mSG_UPLOAD_DOC = data["MSG_UPLOAD_DOC"] as? String ?? "Please upload document"
        iNVALID_DOC = data["INVALID_DOC"] as? String ?? "More then 10 document not allow"
        lOGGED_IN_SUCCESSFULL = data["LOGGED_IN_SUCCESSFULL"] as? String ?? "logged in successful"
        aCCOUNT_NOT_ACTIVE = data["ACCOUNT_NOT_ACTIVE"] as? String ?? "Your account is not active."
        iNVALID_EMAIL_PWD = data["INVALID_EMAIL_PWD"] as? String ?? "Invalid email address or wrong password."
        rEGI_SUCCESSFUL = data["REGI_SUCCESSFUL"] as? String ?? "Registration successful. Please wait for admin approval."
        mOBILE_NUMBER_EXIST = data["MOBILE_NUMBER_EXIST"] as? String ?? "Mobile number already exist"
        eMAIL_EXISTS = data["EMAIL_EXISTS"] as? String ?? "Email already exist"
        nO_RECORD_FOUND = data["NO_RECORD_FOUND"] as? String ?? "No record found"
        lOCATION_ADDED_SUCCESSFULLY = data["LOCATION_ADDED_SUCCESSFULLY"] as? String ?? "Location Added Successfully"
        lOCATION_REMOVED_SUCCESSFULLY = data["LOCATION_REMOVED_SUCCESSFULLY"] as? String ?? "Location Removed Successfully"
        rEDEEM_REQUEST_SUCCESSFULLY = data["REDEEM_REQUEST_SUCCESSFULLY"] as? String ?? "Redeem requested successfully"
        nOT_SUFFICIENT_BALANCE_WALLET = data["NOT_SUFFICIENT_BALANCE_WALLET"] as? String ?? "empty"
        uSER_NOT_FOUND = data["USER_NOT_FOUND"] as? String ?? "You don't have sufficient balence in wallet"
        eNTER_PROPER_EMAIL = data["ENTER_PROPER_EMAIL"] as? String ?? "Please enter proper paypal email"
        fEEDBACK_ADDED_SUCCESSFULL = data["FEEDBACK_ADDED_SUCCESSFULL"] as? String ?? "feedback added successful"
        pARTNER_NOT_FOUND = data["PARTNER_NOT_FOUND"] as? String ?? "partner not found"
        fUND_DEPOSIT_SUCCESSFUL = data["FUND_DEPOSIT_SUCCESSFUL"] as? String ?? "Fund Deposit successful"
        aDD_TRANSACTION_ID = data["ADD_TRANSACTION_ID"] as? String ?? "Please add transactionId"
        nO_PAYMENT_STATUS = data["NO_PAYMENT_STATUS"] as? String ?? "No Payment Staus"
        pLEASE_ADD_AMOUNT = data["PLEASE_ADD_AMOUNT"] as? String ?? "Please add amount"
        pROFILE_UPDATED_SUCCESSFULLY = data["PROFILE_UPDATED_SUCCESSFULLY"] as? String ?? "profile update request sent successfully. Please wait for admin approval."
        pLEASE_UPLOAD_SELFIE = data["PLEASE_UPLOAD_SELFIE"] as? String ?? "Please upload selfie"
        oNLY_JPG_FILE = data["ONLY_JPG_FILE"] as? String ?? "only allow jpg file type"
        rEPORT_SUBMITTED_SUCCESSFULLY = data["REPORT_SUBMITTED_SUCCESSFULLY"] as? String ?? "report submitted successfully"
        pLEASE_ADD_DESC = data["PLEASE_ADD_DESC"] as? String ?? "Please add description"
        pLEASE_ADD_SUBJECT = data["PLEASE_ADD_SUBJECT"] as? String ?? "Please add subject"
        sUBCATEGORY_NOT_FOUND = data["SUBCATEGORY_NOT_FOUND"] as? String ?? "Sub category not found"
        aLREADY_AT_DROPOFF_LOC = data["ALREADY_AT_DROPOFF_LOC"] as? String ?? "You are aleady at dropoff location"
        sELECT_DROPOFF_LOCATION = data["SELECT_DROPOFF_LOCATION"] as? String ?? "Please select proper dropoff location"
        pLEASE_SELECT_PROPER_LOCATION = data["PLEASE_SELECT_PROPER_LOCATION"] as? String ?? "Please select proper location"
        pLEASE_UPLOAD_DOCUMENTS = data["PLEASE_UPLOAD_DOCUMENTS"] as? String ?? "Please upload documents"
        cAR_ADDED_SUCCESSFULLY = data["CAR_ADDED_SUCCESSFULLY"] as? String ?? "Car added request sent successfully. Please wait for admin approval"
        eNTER_CAR_NUMBER = data["ENTER_CAR_NUMBER"] as? String ?? "Please enter car number"
        sELECT_SUB_CAR_TYPE = data["SELECT_SUB_CAR_TYPE"] as? String ?? "Please select sub car type"
        sELECT_CAR_TYPE = data["SELECT_CAR_TYPE"] as? String ?? "Please select car type"
        sELECT_BRAND = data["SELECT_BRAND"] as? String ?? "Please select brand"
        cAR_NUMBER_ALREADY_EXISTS = data["CAR_NUMBER_ALREADY_EXISTS"] as? String ?? "Car Number already exists in our system"
        cAR_UPDATED_SUCCESSFULLY = data["CAR_UPDATED_SUCCESSFULLY"] as? String ?? "Car update request sent successfully. Please wait for admin approval"
        nO_CAR_FOUND = data["NO_CAR_FOUND"] as? String ?? "No car found"
        sELECT_CAR_SUB_TYPE = data["SELECT_CAR_SUB_TYPE"] as? String ?? "Please select car sub type"
        cAR_DELETED_SUCCESSFULLY = data["CAR_DELETED_SUCCESSFULLY"] as? String ?? "Car delete request sent successfully. Please wait for admin approval."
        vIEW_PDF = data["VIEW_PDF"] as? String ?? "View PDF"
        dOWPDF = data["DOWPDF"] as? String ?? "Download PDF"
        pDF_DONLOADING = data["PDF_DONLOADING"] as? String ?? "PDF Downloading..."
        pDF_DOW_SUCCESS = data["PDF_DOW_SUCCESS"] as? String ?? "Downloaded successful"
        yOU_ARE_ONLINE = data["YOU_ARE_ONLINE"] as? String ?? "You are now online"
        dRIVER_NOT_FOUND = data["DRIVER_NOT_FOUND"] as? String ?? "Driver not found"
        rIDE_ACCEPTED_SUCCESSFULLY = data["RIDE_ACCEPTED_SUCCESSFULLY"] as? String ?? "Ride accepted successfully"
        aLREADY_IN_RIDE = data["ALREADY_IN_RIDE"] as? String ?? "You are already in ride"
        rIDE_ALREADY_ACCEPTED_CANCELLED = data["RIDE_ALREADY_ACCEPTED_CANCELLED"] as? String ?? "Ride is already accepted by other one or canceled."
        pLEASE_GO_ONLINE = data["PLEASE_GO_ONLINE"] as? String ?? "Please go online first"
        lOCATION_UPDATED_SUCCESSFULLY = data["LOCATION_UPDATED_SUCCESSFULLY"] as? String ?? "Location updated successfully"
        yOU_ARE_NOW_OFFLINE = data["YOU_ARE_NOW_OFFLINE"] as? String ?? "You are now offline"
        pLEASE_COMPLETE_RIDE = data["PLEASE_COMPLETE_RIDE"] as? String ?? "Please complete the ride first"
        yOU_ARE_ALREADY_OFFLINE = data["YOU_ARE_ALREADY_OFFLINE"] as? String ?? "You are already offline"
        cONTACT_DETAILS_SUBMITTED = data["CONTACT_DETAILS_SUBMITTED"] as? String ?? "Contact details submitted"
        pLEASE_ENTER_MOBILE_NO = data["PLEASE_ENTER_MOBILE_NO"] as? String ?? "Please enter mobile number"
        pLEASE_ENTER_COUNTRY_CODE = data["PLEASE_ENTER_COUNTRY_CODE"] as? String ?? "Please enter country code"
        pLEASE_ENTER_EMAIL_ADDRESS = data["PLEASE_ENTER_EMAIL_ADDRESS"] as? String ?? "Please enter email address"
        nEW_PWD_SENT = data["NEW_PWD_SENT"] as? String ?? "New password is mail to email address, please check your mail inbox"
        dEVICE_REGISTERED_SUCCESSFULLY = data["DEVICE_REGISTERED_SUCCESSFULLY"] as? String ?? "Device registred successfully"
        dEVICE_ALREADY_REGISTER = data["DEVICE_ALREADY_REGISTER"] as? String ?? "Device already register"
        dEVICE_TOKEN_NOT_FOUND = data["DEVICE_TOKEN_NOT_FOUND"] as? String ?? "device token not found"
        dEVICE_NOT_FOUND = data["DEVICE_NOT_FOUND"] as? String ?? "Device not found"
        lOGOUT_SUCCESSFULLY = data["LOGOUT_SUCCESSFULLY"] as? String ?? "Logout successfully"
        oLD_PWD_DIFFERENT_NEW = data["OLD_PWD_DIFFERENT_NEW"] as? String ?? "old password should diffrent than new password"
        rIDE_NOT_FOUND = data["RIDE_NOT_FOUND"] as? String ?? "Ride not found"
        rIDE_STARTED_SUCCESSFULLY = data["RIDE_STARTED_SUCCESSFULLY"] as? String ?? "Ride started successfully"
        rIDE_REJECTED_SUCCESSFULLY = data["RIDE_REJECTED_SUCCESSFULLY"] as? String ?? "Ride rejected successfully"
        rIDE_COMPLETED_SUCCESSFULLY = data["RIDE_COMPLETED_SUCCESSFULLY"] as? String ?? "Ride completed successfully"
        rIDE_CANCELLED_SUCCESSFULLY = data["RIDE_CANCELLED_SUCCESSFULLY"] as? String ?? "Ride cancelled successfully"
        cAR_BRAND_NOT_FOUND = data["CAR_BRAND_NOT_FOUND"] as? String ?? "Car brand not found"
        cAR_TYPE_NOT_FOUND = data["CAR_TYPE_NOT_FOUND"] as? String ?? "Car type not found"
        sUB_CAR_TYPE_NOT_FOUND = data["SUB_CAR_TYPE_NOT_FOUND"] as? String ?? "Sub Car type not found"
        rECORD_UPDATED_SUCCESSFULLY = data["RECORD_UPDATED_SUCCESSFULLY"] as? String ?? "Record updated successfully"
        rIDE_SET_PANIC = data["RIDE_SET_PANIC"] as? String ?? "Ride is set panic successfully"
        uNKNOWN_USER_TYPE = data["UNKNOWN_USER_TYPE"] as? String ?? "unknown user type"
        vERIFICATION_MAIL_SENT = data["VERIFICATION_MAIL_SENT"] as? String ?? "Verification Mail has been sent to your registered email address."
        cAN_NOT_FOUND_DETAILS = data["CAN_NOT_FOUND_DETAILS"] as? String ?? "We cannot found your required details, please contact admin"
        aCCOUNT_ACTIVATED = data["ACCOUNT_ACTIVATED"] as? String ?? "Account activated successfully"
        aCCOUNT_ALREADY_ACTIVATED = data["ACCOUNT_ALREADY_ACTIVATED"] as? String ?? "Account already activated!"
        uRL_INVALID = data["URL_INVALID"] as? String ?? "Url is invalid"
        aMOUNT_DEPOSIT_SUCCESSFULLY = data["AMOUNT_DEPOSIT_SUCCESSFULLY"] as? String ?? "Amount deposite successfully"
        yOUR_FUND_OF_AMOUNT = data["YOUR_FUND_OF_AMOUNT"] as? String ?? "Your fund of amount"
        sUBMITTED_SUCCESSFULLY = data["SUBMITTED_SUCCESSFULLY"] as? String ?? "report submitted successfully"
        mSG_ACTIVATE_ACOOUNT = data["MSG_ACTIVATE_ACOOUNT"] as? String ?? "Very soon activate your account by admin and notify in mailbox"
        aCCO_NOT_ACTIVE = data["ACCO_NOT_ACTIVE"] as? String ?? "Account not Activated"
        mSG_RESEND = data["MSG_RESEND"] as? String ?? "You have successfully registered for BookNRide. Please check your mail for activation link. Have not received activation mail? Please click on Resend button to send it again"
        rESEND = data["RESEND"] as? String ?? "Resend"
        gOOGLE_CON_FAIL = data["GOOGLE_CON_FAIL"] as? String ?? "empty"
        dATE_ERROR = data["DATE_ERROR"] as? String ?? "empty"
        eRROR = data["ERROR"] as? String ?? "empty"
        gPS_ERROR = data["GPS_ERROR"] as? String ?? "empty"
        iNVALID_REDEEM_AMOUNT = data["INVALID_REDEEM_AMOUNT"] as? String ?? "empty"
        sELECT_PIC = data["SELECT_PIC"] as? String ?? "empty"
        iNSUFFI_AMNT = data["INSUFFI_AMNT"] as? String ?? "empty"
        pDF_NOT_FOUND = data["PDF_NOT_FOUND"] as? String ?? "empty"
        tITLE_SELFEI = data["TITLE_SELFEI"] as? String ?? "empty"
        nOTIFY_CHANGE_PAYMENT = data["NOTIFY_CHANGE_PAYMENT"] as? String ?? "empty"
        nO_EMAIL_EXIST = data["NO_EMAIL_EXIST"] as? String ?? "empty"
        
        //New
        LBL_ACCEPTED = data["LBL_ACCEPTED"] as? String ?? "Accepted"
        TITLE_RIDE_REQUEST =  data["TITLE_RIDE_REQUEST"] as? String ?? "Ride Request"
        LBL_LOCATION_SERVICE_DISABLED =  data["LBL_LOCATION_SERVICE_DISABLED"] as? String ?? "Location services are disabled, Enable via settings.    "
        LBL_LOCATION = data["LBL_LOCATION"] as? String ?? "Location"
        
        MSG_NO_INTERNET = data["MSG_NO_INTERNET"] as? String ?? "Internet"
        MSG_NETWORK = data["MSG_NETWORK"] as? String ?? "No Internet connection, Go to settings to turn on the internet."
        
        REQ_SOCIAL_EMAIL = data["MSG_NETWORK"] as? String ?? "Please select email id in the social login"
        
        MSG_CATEGORY_NOT_AVAILABLE = data["MSG_CATEGORY_NOT_AVAILABLE"] as? String ?? "Category not available"
        
        MSG_DELETE_DEFAULT_CAR = data["MSG_DELETE_DEFAULT_CAR"] as? String ?? "You can not delete default car"
        MSG_ONLY_CAR = data["MSG_ONLY_CAR"] as? String ?? "You can not delete the only car"
        
        MSG_SELECT_TO_DATE = data["MSG_SELECT_TO_DATE"] as? String ?? "Please select to date"
        MSG_SELECT_FROM_DATE = data["MSG_SELECT_FROM_DATE"] as? String ?? "Please select from date"
        
        MSG_NOT_AVAILABLE = data["MSG_NOT_AVAILABLE"] as? String ?? "Messaging not available"
    }
}

class AppConst{
    static var shared = AppConst()
    
    var const:Const = Const(data: [:])
    
    init() {
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/bnrPartnerConts.plist")
        if fileManager.fileExists(atPath: path) {
            guard let dict = NSDictionary(contentsOfFile: path) else { return  }
            setConst(data: dict as! [String : Any])
        } else {
            setConst(data: [:])
        }
    }
    
    func setConst(data:[String:Any]){
        const = Const(data: data)
    }
}
