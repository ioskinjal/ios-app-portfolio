//
//  YuppModel.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 28/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

@objcMembers public class YuppModel: NSObject {
    //MARK: - Datatype check
    
    func getMarketColorString(value : Any?) -> String {
        guard let object = value as? String else {
            return ""
        }
        return (object.count > 6 ? String(object.suffix(6)) : object)
    }
    
    func getString(value : Any?) -> String {
        guard let object = value as? String else {
            return ""
        }
        return object
    }
    
    func getInt(value : Any?) -> Int {
        return getInt(value: value, defaultValue: 0)
    }

    func getCLong(value : Any?, defaultValue : Int) -> CLong {
        guard let object = value as? CLong else {
            return defaultValue
        }
        return object
    }

    
    
    func getInt(value : Any?, defaultValue : Int) -> Int {
        guard let object = value as? Int else {
            // Assuming string
            if let stringObject = value as? String {
                if let intVal = Int(stringObject) {
                    return intVal
                }
            }
            return defaultValue
        }
        return object
    }
    
    func getFloat(value : Any?) -> Float {
        guard let object = value as? Float else {
            // Assuming string
            if let stringObject = value as? String {
                print("stringObject:\(stringObject)")
                if let floatVal = Float(stringObject) {
                    print("floatVal:\(floatVal)")
                    return floatVal
                }
            }
            return 0
        }
        print("object:\(object)")
        return object
    }
    
    func getDouble(value : Any?) -> Double {
        guard let object = value as? Double else {
            // Assuming string
            if let stringObject = value as? String {
                print("stringObject:\(stringObject)")
                if let doubleVal = Double(stringObject) {
                    print("doubleVal:\(doubleVal)")
                    return doubleVal
                }
            }
            return 0
        }
        print("object:\(object)")
        return object
    }
    
    func getNSNumber(value : Any?) -> NSNumber {
        
        guard let object = value as? NSNumber else {
            // Assuming string
            if let stringObject = value as? String {
                if let integer = Int(stringObject) {
                    return NSNumber(value:integer)
                }
            }
            return NSNumber()
        }
        return object
    }
    
    func getBool(value : Any?) -> Bool {
        guard let object = value as? Bool else {
            // Assuming string
            if let strObj = value as? String{
                return Bool.init(strObj.lowercased()) ?? false
            }
            return false
        }
        return object
    }
    
    public func getImageUrl(value : Any?) -> String {
        guard let postfix =  value as? String, postfix.count > 0 else {
            return ""
        }
        if postfix.hasPrefix("http"){
            return postfix
        }
        var resourceProfileName = ""
        var partialImagePath = ""
        var strings = postfix.components(separatedBy: ",")
        if strings.count == 1{
            partialImagePath = strings[0]
        }
        else if strings.count > 1{
            resourceProfileName = strings[0]
            partialImagePath = strings[1]
        }
        
        
        if let configResponse = ConfigResponse.StoredConfig.getConfigResponse(currentDate: Date()){
            let configResource = configResponse.resourceProfiles
            guard  configResource.count > 0 else {
                return ""
            }
            let array = configResource.filter { $0.code == resourceProfileName }
            if array.count > 0{
                let prefix = array[0].urlPrefix
                return prefix + partialImagePath
            }
            else{
                let array = configResource.filter { $0.isDefault == true }
                if array.count > 0{
                    let prefix = array[0].urlPrefix
                    return prefix + partialImagePath
                }
                else{
                    let prefix = configResource[0].urlPrefix
                    return prefix + partialImagePath
                }
            }
        }
        return ""
    }
    
    public func safeValueForKey(key: String) -> AnyObject? {
        let copy = Mirror(reflecting: self)
        
        for child in copy.children.makeIterator() {
            if let label = child.label, label == key {
                return child.value as AnyObject
            }
        }
        return nil
    }
}
