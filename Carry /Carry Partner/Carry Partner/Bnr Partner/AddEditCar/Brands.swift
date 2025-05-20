//
//  Brands.swift
//  BnR Partner
//
//  Created by KASP on 12/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class Brands: NSObject {

    
    var brandId = ""
    var brandName = ""

    override init() {
        
    }
    
    
    
    class func initWithResponse(array:[Any]?) -> [Brands]{
        
        var allBrands = [Brands]()
        
        
        guard let tempArray = array else { return [Brands]() }
        
        
        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let newBrand = Brands()
            
            if valid.isNotNull(object: item.object(forKey: "brandId") as AnyObject){
                newBrand.brandId = String(format:"%@",item.object(forKey: "brandId") as! CVarArg)
            }
            if valid.isNotNull(object: item.object(forKey: "brandName") as AnyObject){
                newBrand.brandName = String(format:"%@",item.object(forKey: "brandName") as! NSString)
            }
            
            allBrands.append(newBrand)
        }
        
        return allBrands
    }
    
}
