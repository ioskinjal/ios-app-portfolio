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
}

// Encryption
extension Utility {
    
    static func getEncryptedArgumentFor(dataDictionary : [String : Any], requestType : String) -> [String : Any] {
        var data = ""
        var metaData = ""
        
        //Data
        if let jsonString = getJsonStringForDictionary(dictionary: dataDictionary){
            data = try! aesEncrypt(message: jsonString)
        }
        
        //Meta Data
        var metaDataDict = [String : String]()
        metaDataDict  = ["request":requestType]
        
        if let jsonString = getJsonStringForDictionary(dictionary: metaDataDict){
            metaData = try! aesEncrypt(message: jsonString)
        }
        
        var dec = try! aesDecrypt(encryptedMessage: data)
        print("--------------data :-------------------------\n" + data + "\n" + dec)
        
        dec = try! aesDecrypt(encryptedMessage: metaData)
        print("--------------metaData :-------------------------\n" + metaData + "\n" + dec)
        
        return ["data" : data, "metadata" : metaData]
    }
    
    internal static func aesEncrypt(message : String) throws -> String {
        let data = message.data(using: .utf8)!
        let encrypted = try! AES(key:  PreferenceManager.encKey , iv: PreferenceManager.encIV, blockMode: .CBC, padding: .pkcs7).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        print("-------message : ",message)
        print("-------data : ",encryptedData.base64EncodedString())
        return encryptedData.base64EncodedString()
    }
    
    internal static func aesDecrypt(encryptedMessage : String) throws -> String {
        let data = Data(base64Encoded: encryptedMessage)!
        let decrypted = try! AES(key:  PreferenceManager.encKey , iv: PreferenceManager.encIV, blockMode: .CBC, padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        let message = String(bytes: decryptedData.bytes, encoding: .utf8)
        return message ?? "Could not decrypt"
    }
    
    static func getJsonStringForDictionary(dictionary : [String : Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.utf8)
        } catch{
            return nil
        }
    }
}
