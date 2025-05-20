//
//  SubCar.swift
//  BooknRide
//
//  Created by NCrypted on 07/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class SubCar: NSObject {

    var typeId = ""
    var subTypeImage = ""
    var subTypeName = ""
    
    override init() {
        
    }
    
    class func initWithResponse(array:[Any]?) -> [Any]{
        
        var cars = [SubCar]()
        
        
        guard let tempArray = array else { return [SubCar]() }
        
        
        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let currentCar = SubCar()
            
            if valid.isNotNull(object: item.object(forKey: "id") as AnyObject){
                currentCar.typeId = String(format:"%@",item.object(forKey: "id") as! CVarArg)
                
            }

            if valid.isNotNull(object: item.object(forKey: "subTypeImage") as AnyObject){
                
                currentCar.subTypeImage = String(format:"%@",item.object(forKey: "subTypeImage") as! CVarArg)
            }
            if valid.isNotNull(object: item.object(forKey: "subTypeName") as AnyObject){
                
                currentCar.subTypeName = String(format:"%@",item.object(forKey: "subTypeName") as! CVarArg)
            }
            
            cars.append(currentCar)
            
        }
        
        
        return cars
    }
    
}
