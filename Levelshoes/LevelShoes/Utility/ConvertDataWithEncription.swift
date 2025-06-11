//
//  ConvertData.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

// Convert from NSData to json object
func nsdataToJSON(data: NSData) -> AnyObject? {
    do {
        return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil
}

// Convert from JSON to nsdata
func jsonToNSData(json: AnyObject) -> NSData?{
    do {
        return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil;
}

//MARK:- Randam number satring Genrater
func randomString(length: Int) -> String {
   let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
   return String((0..<length).map{ _ in letters.randomElement()! })
 }
 
//MARK:- Encrpt The String
 func encryptIt(salt: String, value: String) -> String {
     let secretKey = salt
     let secretIv = randomString(length: 16)
     let ivString: String = String(secretIv.sha256().prefix(16))
     let data = value.data(using: String.Encoding.utf8)
     var result = ""
     do {
         let aes = try AES(key: secretKey, iv: ivString, padding: .pkcs7)
         let enc = try aes.encrypt(data!.bytes)
      let encData = NSData(bytes: enc, length: Int(enc.count))
      let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
      let outpul  = base64String+"::"+ivString
      if let data = (outpul).data(using: String.Encoding.utf8) {
          let base64 = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
          //print(base64)
           result = String(base64)
        
      }
     } catch {
      print("Error \(error)")
     }
    return result
 }
func orderEncrypt(key:String, text: String) throws -> String {
    let secretKey = key
    let secretIv = randomString(length: 16)
    //let ivString: String = String(secretIv.sha256().prefix(16))
    let data = text.data(using: .utf8)!
    
    do {
        let aes = try AES(key: secretKey, iv: secretIv, padding: .pkcs7).encrypt([UInt8](data))
        let encryptedData = Data(aes)
         return encryptedData.base64EncodedString()

    } catch {
     print("Error \(error)")
    }
    return ""
}
