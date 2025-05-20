//
//  Car.swift
//  BooknRide
//
//  Created by NCrypted on 06/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class Car: NSObject {

   
    
     var brandId = ""
     var brandName = ""
     var carId = ""
     var carName = ""
     var carNumber = ""
     var carTypeId = ""
     var isDefault = ""
     var selected = ""
     var subTypeImage = ""
     var subTypeName = ""
     var typeImage = ""
     var typeName = ""
    
    
    override init() {
        
    }
    
    class func initWithResponse(array:[Any]?) -> [Car]{
        
        var cars = [Car]()

        
        guard let tempArray = array else { return [Car]() }
     

        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let currentCar = Car()

            
            if valid.isNotNull(object: item.object(forKey: "brandId") as AnyObject){
                currentCar.brandId = "\(item.object(forKey: "brandId") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "brandName") as AnyObject){
                currentCar.brandName = "\(item.object(forKey: "brandName") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "carId") as AnyObject){
                currentCar.carId = "\(item.object(forKey: "carId") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "carName") as AnyObject){
                currentCar.carName = "\(item.object(forKey: "carName") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "carNumber") as AnyObject){
                currentCar.carNumber = "\(item.object(forKey: "carNumber") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "carTypeId") as AnyObject){
                currentCar.carTypeId = "\(item.object(forKey: "carTypeId") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "isDefault") as AnyObject){
                currentCar.isDefault = "\(item.object(forKey: "isDefault") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "selected") as AnyObject){
                currentCar.selected = "\(item.object(forKey: "selected") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "subTypeImage") as AnyObject){
                currentCar.subTypeImage = "\(item.object(forKey: "subTypeImage") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "subTypeName") as AnyObject){
                currentCar.subTypeName = "\(item.object(forKey: "subTypeName") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "typeImage") as AnyObject){
                currentCar.typeImage = "\(item.object(forKey: "typeImage") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "typeName") as AnyObject){
                currentCar.typeName = "\(item.object(forKey: "typeName") ?? "")"
            }
           
            
            cars.append(currentCar)
            
        }
    
        
      return cars
    }
}

class AddCar: NSObject {
    
    
    
    var createdDate = ""
    var id = ""
    var isActive = ""
    var typeImage = ""
    var typeName = ""

    override init() {
        
    }
    
    class func initWithResponse(array:[Any]?) -> [AddCar]{
        
        var cars = [AddCar]()
        
        
        guard let tempArray = array else { return [AddCar]() }
        
        
        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let currentCar = AddCar()
            
            
            if valid.isNotNull(object: item.object(forKey: "createdDate") as AnyObject){
                currentCar.createdDate = "\(item.object(forKey: "createdDate") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "id") as AnyObject){
                currentCar.id = "\(item.object(forKey: "id") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "isActive") as AnyObject){
                currentCar.isActive = "\(item.object(forKey: "isActive") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "typeImage") as AnyObject){
                currentCar.typeImage = "\(item.object(forKey: "typeImage") ?? "")"
            }
            if valid.isNotNull(object: item.object(forKey: "typeName") as AnyObject){
                currentCar.typeName = "\(item.object(forKey: "typeName") ?? "")"
            }
            
            cars.append(currentCar)
            
        }
        
        
        return cars
    }
}

