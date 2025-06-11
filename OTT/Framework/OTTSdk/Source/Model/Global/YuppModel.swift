//
//  YuppModel.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 28/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class YuppModel: NSObject {
    //MARK: - Datatype check
    
    func getString(value : Any?) -> String {
        guard let object = value as? String else {
            return ""
        }
        return object
    }
    
    func getInt(value : Any?) -> Int {
        return getInt(value: value, defaultValue: 0)
    }
    
    func getInt(value : Any?, defaultValue : Int) -> Int {
        guard let object = value as? Int else {
            return defaultValue
        }
        return object
    }
    
    func getFloat(value : Any?) -> Float {
        guard let object = value as? Float else {
            return 0
        }
        return object
    }
    
    func getNSNumber(value : Any?) -> NSNumber {
        guard let object = value as? NSNumber else {
            return NSNumber()
        }
        return object
    }
    
    func getBool(value : Any?) -> Bool {
        guard let object = value as? Bool else {
            return false
        }
        return object
    }
}
