//
//  CountryCode.swift
//  BooknRide
//
//  Created by NCrypted on 09/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class CountryCode: NSObject {
    
    var typeId = ""
    var country_code = ""
    var isActive = ""
    
    override init() {
        
    }
    
    class func initWithResponse(array:[Any]?) -> [Any]{
        
        var allCodes = [CountryCode]()
        
        
        guard let tempArray = array else { return [CountryCode]() }
        
        
        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let code = CountryCode()
            
            
            if valid.isNotNull(object: item.object(forKey: "id") as AnyObject){
                code.typeId = String(format:"%@",item.object(forKey: "id") as! CVarArg)
            }
            
            if valid.isNotNull(object: item.object(forKey: "country_code") as AnyObject){
                code.country_code = String(format:"%@",item.object(forKey: "country_code") as! CVarArg)
                
            }
            if valid.isNotNull(object: item.object(forKey: "isActive") as AnyObject){
                
                code.isActive = String(format:"%@",item.object(forKey: "isActive") as! CVarArg)
            }
            
            
            allCodes.append(code)
            
        }
        
        
        return allCodes
    }
    
    
}
