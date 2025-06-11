//
//  User.swift
//  YuppTV
//
//  Created by Muzaffar on 05/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit


public class User: NSObject, NSCoding {

    public var name = ""
    public var email = ""
    public var cardStatus = false
    public var activeDevices = [ActiveDevice]()
    public var preferences = Preference()
    public var message = ""
    public var userId = ""
    public var mobile = ""
    public var mobileStatus = false
    public var rawData = [String : Any]()
    
    internal override init() {
        super.init()
    }
    
    internal init(withJson response: [String : Any]) {
        rawData = response
        name = Utility.getStringValue(value: response["name"])
        email = Utility.getStringValue(value: response["email"])
        cardStatus = Utility.getBoolValue(value: response["cardStatus"])
        message = Utility.getStringValue(value: response["message"])
        userId = String(Utility.getIntValue(value: response["userId"]))
        mobile = Utility.getStringValue(value: response["mobile"])
        mobileStatus = Utility.getBoolValue(value: response["mobileStatus"])
        
        if let devices = response["activeDevices"] as? [[String : Any]]{
            activeDevices = ActiveDevice.deviceList(json: devices)
        }
        
        if let _preferences = response["preferences"] as? [String : Any]{
            preferences = Preference.init(withJson: _preferences)
        }
        super.init()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        }
        if let email = aDecoder.decodeObject(forKey: "email") as? String {
            self.email = email
        }

        self.cardStatus = aDecoder.decodeBool(forKey: "cardStatus")

        if let activeDevices = aDecoder.decodeObject(forKey: "activeDevices") as? [ActiveDevice] {
            self.activeDevices = activeDevices
        }
        if let preferences = aDecoder.decodeObject(forKey: "preferences") as? Preference {
            self.preferences = preferences
        }
        if let message = aDecoder.decodeObject(forKey: "message") as? String {
            self.message = message
        }
        if let userId = aDecoder.decodeObject(forKey: "userId") as? String {
            self.userId = userId
        }
        if let mobile = aDecoder.decodeObject(forKey: "mobile") as? String {
            self.mobile = mobile
        }
        
        self.mobileStatus = aDecoder.decodeBool(forKey: "mobileStatus")
     
        if let rawData = aDecoder.decodeObject(forKey: "rawData") as? [String : Any] {
            self.rawData = rawData
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(cardStatus, forKey: "cardStatus")
        aCoder.encode(activeDevices, forKey: "activeDevices")
        aCoder.encode(preferences, forKey: "preferences")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(mobileStatus, forKey: "mobileStatus")
        aCoder.encode(rawData, forKey: "rawData")
    }
    
    public override var description: String{
        return "name=\(name)" + "\n" + "email=\(email)" + "\n" + "mobile=\(mobile)" + "\n" + "userId=\(userId)"
    }
}
