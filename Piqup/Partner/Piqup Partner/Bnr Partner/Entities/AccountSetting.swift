//
//  AccountSetting.swift
//  BooknRide
//
//  Created by KASP on 27/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class AccountSetting: NSObject {
    
    var ride_cancel = "n";
    var ride_complete = "n";
    var deposit_fund = "n";
    var redeem_request_accept_or_reject = "n";
    var panicCountryNumber = ""
    var panicNumber = ""
    var paypalEmail = ""

    class func initWithResponse(array:[Any]?) -> AccountSetting{
        
        let settings = AccountSetting()
        
        let valid = Validator()

        guard let tempArray = array else { return AccountSetting() }
        
        let dataDict = tempArray[0] as! NSDictionary
        
        let accountSettingsArray = dataDict.object(forKey: "accountSettings") as! NSArray
        
        for (_, element) in accountSettingsArray.enumerated() {
            
            let dictNotification = element as! NSDictionary
            
            let notifyType = "\(dictNotification.object(forKey: "notifyType") ?? "")"
            let notifyAns = "\(dictNotification.object(forKey: "notifyAns") ?? "n")"
            
            if  notifyType  == "ride_cancel"{
                if valid.isNotNull(object: notifyAns as AnyObject){

                settings.ride_cancel = notifyAns
                }
            }
            else if notifyType  == "ride_complete"{
                if valid.isNotNull(object: notifyAns as AnyObject){

                settings.ride_complete = notifyAns
                }
            }
            else if notifyType  == "deposit_fund"{
                if valid.isNotNull(object: notifyAns as AnyObject){

                settings.deposit_fund = notifyAns
                }
            }
            else if notifyType == "redeem_request_accept_or_reject"{
                if valid.isNotNull(object: notifyAns as AnyObject){

                settings.redeem_request_accept_or_reject = notifyAns
                }
            }
            
            
        }
        
        if valid.isNotNull(object: dataDict.object(forKey: "panicCountryNumber") as AnyObject){
            settings.panicCountryNumber = "\(dataDict.object(forKey: "panicCountryNumber") ?? "")"

        }
        if valid.isNotNull(object: dataDict.object(forKey: "panicNumber") as AnyObject){
            settings.panicNumber = "\(dataDict.object(forKey: "panicNumber") ?? "")"

        }
        if valid.isNotNull(object: dataDict.object(forKey: "paypalEmail") as AnyObject){
            settings.paypalEmail = "\(dataDict.object(forKey: "paypalEmail") ?? "")"

        }
        
        return settings
    }
    
}
