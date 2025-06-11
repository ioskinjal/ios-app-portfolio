//
//  Utility.swift
//  YuppTV
//
//  Created by Muzaffar on 04/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

class Utility: NSObject {

    //MARK:- keychain Methods
    let keychain = KeychainSwift()
    
    
    static var sharedInstance : Utility {
        get{
            struct Singlton{
                static let utility = Utility()
            }
            return Singlton.utility
        }
    }
    
    fileprivate override init() {
        super.init()
    }
    
    func onSaveKeychain(keyName: String, keyValue: String) {
        if keyName != "" && keyValue != "" {
            keychain.set(keyValue, forKey: keyName)
        }
    }
    
    func onGetKeychain(keyName: String) -> String {
        if let value = keychain.get(keyName) {
            return value
        } else {
            return ""
        }
    }
    
    func onSaveKeychainBool(keyName: String, keyValue: Bool) {
        keychain.set(keyValue, forKey: keyName)
        
    }
    
    func onGetKeychainBool(keyName: String) -> Bool {
        if let value = keychain.getBool(keyName) {
            return value
        } else {
            return false
        }
    }
    
    func onDeleteKeychain(keyName: String) {
        if let value = keychain.get(keyName) {
            print("deleting key value\(value)")
            keychain.delete(keyName)
        }
    }
    
    func onClearAllKeychains() {
        keychain.clear()
    }

    //MARK: - Datatype check
    
    static func getStringValue(value : Any?) -> String {
        guard let object = value as? String else {
            return ""
        }
        return object
    }
    
    static func getIntValue(value : Any?) -> Int {
        guard let object = value as? Int else {
            return 0
        }
        return object
    }
    
    static func getFloatValue(value : Any?) -> Float {
        guard let object = value as? Float else {
            return 0
        }
        return object
    }
    
    static func getNSNumberValue(value : Any?) -> NSNumber {
        guard let object = value as? NSNumber else {
            return NSNumber()
        }
        return object
    }
    
    static func getBoolValue(value : Any?) -> Bool {
        guard let object = value as? Bool else {
            return false
        }
        return object
    }
    
    static internal func validateMobile(number: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = number.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  number == filtered
    }
    
    static internal func appVersion() -> String{
        if let infoDictionary = Bundle.main.infoDictionary{
            if let _appVersion = infoDictionary["CFBundleShortVersionString"] as? String{
                return _appVersion
            }
        }
        return ""
    }
    
    /**
     metadata - String (encrypted metadata as string)
     o  metadata has information of request and its processing. It should have request
     and datatype filed.
     o  request can be one of "movie/play", "movie/stream/request",
     "movie/stream/status"
     o  datatype is json for all these 3 requests.
     */
    /*
    static func getEncryptedArgumentFor(dataDictionary : [String : String], requestType : String) -> String? {
        var data = ""
        var metaData = ""
        
        //Data
        if let jsonString = getJsonStringForDictionary(dictionary: dataDictionary){
            data = generateEncryptedContent(_plainContent: jsonString)
        }
        
        //Meta Data
        var metaDataDict = [String : String]()
        if requestType == "tvshow/stream/request"{
            //TV Shows
            metaDataDict  = ["request":requestType,"device_type":"\(PreferenceManager.deviceType)"]
        }
        else{
            // Premieres
            metaDataDict  = ["request":requestType,"datatype":"json"]
        }
        if let jsonString = getJsonStringForDictionary(dictionary: metaDataDict){
            metaData = generateEncryptedContent(_plainContent: jsonString)
        }
        return getJsonStringForDictionary(dictionary: ["data" : data, "metadata" : metaData])
    }
    
     static func generateEncryptedContent(_plainContent: String) -> String {
        var plainContent = _plainContent
        if (getEncKey().characters.count > 0) {
            let encryptedData = StringEncryption.encrypt(plainContent.data(using: String.Encoding.utf8), key: getEncKey(), iv: PreferenceManager.encIV)
            if (encryptedData?.base64EncodedString()) == nil{
                return plainContent
            }
            plainContent = (encryptedData?.base64EncodedString())!
        }
        return plainContent
    }
    
    static func generateDecryptContent(encryptedContent: String) -> Any {
        var decryptedContent : Any?
        if getEncKey().characters.count > 0 {
            let encryptedContentBase64 = NSData(base64EncodedString: encryptedContent)
            let encryptedData = StringEncryption.decrypt(encryptedContentBase64! as Data, key: getEncKey(), iv:PreferenceManager.encIV)
            do {
                decryptedContent = try JSONSerialization.jsonObject(with: encryptedData!, options: JSONSerialization.ReadingOptions.mutableContainers)
            }
            catch _ {
                return ""
            }
            if decryptedContent is String{
                decryptedContent = String(data: encryptedData!, encoding: String.Encoding.utf8)!
            }
        }
        APILog.printMessage(message: "Encrypted data: \(encryptedContent)\n", logType: .response)
        APILog.printMessage(message: "Decrypted data: \(String(describing: decryptedContent))", logType: .response)
        
        //print the decrypted text
        if decryptedContent != nil {
            return decryptedContent!
        }
        return ""
    }
    
    static func getJsonStringForDictionary(dictionary : [String : String]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.utf8)
        } catch{
            return nil
        }
    }
    
    static func setEncKey(encKey: String) {
        var key = ""
        if encKey.characters.count > 0 {
            key = StringEncryption.sha256(encKey, length: 32)
        }
        let pref = UserDefaults.standard
        pref.set(key, forKey: "UserEncKey")
        pref.synchronize()
    }
    
    static func getEncKey() -> String {
        let pref = UserDefaults.standard
        return pref.object(forKey: "UserEncKey") as! String
    }
    */
}
