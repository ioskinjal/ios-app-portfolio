//
//  Car.swift
//  BooknRide
//
//  Created by NCrypted on 06/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class Car: NSObject {

    var createdDate = ""
    var typeId = ""
    var isActive = ""
    var typeImage = ""
    var typeName = ""
    
    override init() {
        
    }
    
    class func initWithResponse(array:[Any]?) -> [Any]{
        
        var cars = [Car]()

        
        guard let tempArray = array else { return [Car]() }
     

        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let currentCar = Car()

            
            if valid.isNotNull(object: item.object(forKey: "createdDate") as AnyObject){
                currentCar.createdDate = String(format:"%@",item.object(forKey: "createdDate") as! CVarArg)
            }
            
            if valid.isNotNull(object: item.object(forKey: "id") as AnyObject){
                currentCar.typeId = String(format:"%@",item.object(forKey: "id") as! CVarArg)

            }
            if valid.isNotNull(object: item.object(forKey: "isActive") as AnyObject){

                currentCar.isActive = String(format:"%@",item.object(forKey: "isActive") as! CVarArg)
            }
            if valid.isNotNull(object: item.object(forKey: "typeImage") as AnyObject){

                currentCar.typeImage = String(format:"%@",item.object(forKey: "typeImage") as! CVarArg)
            }
            if valid.isNotNull(object: item.object(forKey: "typeName") as AnyObject){

                currentCar.typeName = String(format:"%@",item.object(forKey: "typeName") as! CVarArg)
            }
            
            cars.append(currentCar)
            
        }
    
        
      return cars
    }
}
