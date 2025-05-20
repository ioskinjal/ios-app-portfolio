//
//  Validator.swift
//  BooknRide
//
//  Created by NCrypted on 02/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class Validator: NSObject {

    
   public func isValidEmail(emailStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: emailStr)
    }
    
    func isNotNull(object:AnyObject?) -> Bool {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object: object) && isNotStringNull(object: object))
    }
    func isNotNSNull(object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
    
    func isNotStringNull(object:AnyObject) -> Bool {
        if let object = object as? String, object.uppercased() == "NULL", object.lowercased() == "(null)", object.lowercased() == "null" {
            return false
        }
        return true
    }

}
