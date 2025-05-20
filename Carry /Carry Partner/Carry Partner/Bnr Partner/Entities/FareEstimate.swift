//
//  FareEstimate.swift
//  BooknRide
//
//  Created by NCrypted on 09/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class FareEstimate: NSObject {

    var carTypeImage = ""
    var carTypeName = ""
    var dropOffLocation = ""
    
    var estimateExtraKm = ""
    var estimateTime = 0
    var estmatedTimeCharges = ""
    
    var fareAdditionalCharges = 0
    var fareDistance = 0
    var fareDistanceCharges = 0
    
    var fareTime = 0
    var fareTimeCharges = 0
    var finalEstimatedTotal = ""
    
    var isLongRide = ""
    var longTripDistance = 0
    var pickUpLocation = ""
    
    var reachedLocation = ""
    var ridePathString = ""
    var subCarTypeImage = ""
    
    var subCarTypeName = ""
    var timeChargesPerMin = ""
    var totalDistance = ""
    var totalExtraCharges = ""
    
    
    override init() {
        
    }
    
    class func initWithResponse(dictionary:[String:Any]?) -> FareEstimate {
        guard let dictionary = dictionary else { return FareEstimate() }
        
        let fare = FareEstimate()
        
        let valid = Validator()
        
        let dictFare = dictionary as NSDictionary
        
        if valid.isNotNull(object: dictFare.object(forKey: "carTypeImage") as AnyObject){
            fare.carTypeImage = "\(dictFare.object(forKey: "carTypeImage") ?? "")"
        }
        
        if valid.isNotNull(object: dictFare.object(forKey: "carTypeName") as AnyObject){
            fare.carTypeName = "\(dictFare.object(forKey: "carTypeName") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLocation") as AnyObject){
            fare.dropOffLocation = "\(dictFare.object(forKey: "dropOffLocation") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "estimateExtraKm") as AnyObject){
            fare.estimateExtraKm = "\(dictFare.object(forKey: "estimateExtraKm") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "estimateTime") as AnyObject){
            fare.estimateTime = dictFare.object(forKey: "estimateTime") as! Int
        }
        if valid.isNotNull(object: dictFare.object(forKey: "estmatedTimeCharges") as AnyObject){
            fare.estmatedTimeCharges = "\(dictFare.object(forKey: "estmatedTimeCharges") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareAdditionalCharges") as AnyObject){
            fare.fareAdditionalCharges = (dictFare.object(forKey: "fareAdditionalCharges") as! NSString).integerValue
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareDistance") as AnyObject){
            fare.fareDistance = (dictFare.object(forKey: "fareDistance") as! NSString).integerValue
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareDistanceCharges") as AnyObject){
            fare.fareDistanceCharges = (dictFare.object(forKey: "fareDistanceCharges") as! NSString).integerValue
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareTime") as AnyObject){
            fare.fareTime = (dictFare.object(forKey: "fareTime") as! NSString).integerValue
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareTimeCharges") as AnyObject){
            fare.fareTimeCharges = (dictFare.object(forKey: "fareTimeCharges") as! NSString).integerValue
        }
        if valid.isNotNull(object: dictFare.object(forKey: "finalEstimatedTotal") as AnyObject){
            fare.finalEstimatedTotal = String(format:"%@",dictionary["finalEstimatedTotal"] as! CVarArg)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "isLongRide") as AnyObject){
            fare.isLongRide = String(format:"%@",dictionary["isLongRide"] as! CVarArg)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "longTripDistance") as AnyObject){
            fare.longTripDistance = (dictFare.object(forKey: "longTripDistance") as! NSString).integerValue
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLocation") as AnyObject){
            fare.pickUpLocation = String(format:"%@",dictionary["pickUpLocation"] as! CVarArg)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "reachedLocation") as AnyObject){
            fare.reachedLocation = String(format:"%@",dictionary["reachedLocation"] as! CVarArg)

        }
        if valid.isNotNull(object: dictFare.object(forKey: "ridePathString") as AnyObject){
            fare.ridePathString = String(format:"%@",dictionary["ridePathString"] as! CVarArg)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "subCarTypeImage") as AnyObject){
            fare.subCarTypeImage = String(format:"%@",dictionary["subCarTypeImage"] as! CVarArg)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "subCarTypeName") as AnyObject){
            fare.subCarTypeName = String(format:"%@",dictionary["subCarTypeName"] as! CVarArg)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "timeChargesPerMin") as AnyObject){
            fare.timeChargesPerMin = String(format:"%@",dictionary["timeChargesPerMin"] as! CVarArg)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalDistance") as AnyObject){
            fare.totalDistance = String(format:"%@",dictionary["totalDistance"] as! CVarArg)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalExtraCharges") as AnyObject){
            fare.totalExtraCharges = String(format:"%@",dictionary["totalExtraCharges"] as! CVarArg)
        }
       
        
        
        return fare
    }
}

class FareSummary: NSObject {
    
    var finalTotalRidePrice = ""
    var payByCash = ""
    var payByWallet = ""
    var totalKm = ""
    
    var perKmAmount = ""
    var totalFareAmount = ""
    
    var carBrand = ""
    var carName = ""
    var carNumber = ""
    var carTypeImage = ""
    var carTypeName = ""
    var dropOffLocation = ""
    var dropOffLong = ""
    var dropoffLat = ""
    
    var perKmPrice = ""
    var totalExtraKm = ""
    
    var pickUpLocation = ""
    var pickUpLong = ""
    var pickupLat = ""
    var subCarTypeImage = ""
    var subCarTypeName = ""
    
    var perMinFareAmount = ""
    var totalTime = ""
    
    override init() {
        
    }
    
    class func initWithResponse(dictionary:[String:Any]?) -> FareSummary {
        guard let dictionary = dictionary else { return FareSummary() }
        
        let fare = FareSummary()
        
        let valid = Validator()
        
        let dictFare = dictionary as NSDictionary
        
        // Getting Final Amount Data from Object
        if valid.isNotNull(object: dictFare.object(forKey: "FinalAmount") as AnyObject){
            
            let dictFinalAmount:NSDictionary = dictFare.object(forKey: "FinalAmount") as! NSDictionary
            
            if valid.isNotNull(object: dictFinalAmount.object(forKey: "finalTotalRidePrice") as AnyObject){
                fare.finalTotalRidePrice = "\(dictFinalAmount.object(forKey: "finalTotalRidePrice") ?? "")"
            }
            if valid.isNotNull(object: dictFinalAmount.object(forKey: "payByCash") as AnyObject){
                fare.payByCash = "\(dictFinalAmount.object(forKey: "payByCash") ?? "")"
            }
            if valid.isNotNull(object: dictFinalAmount.object(forKey: "payByWallet") as AnyObject){
                fare.payByWallet = "\(dictFinalAmount.object(forKey: "payByWallet") ?? "")"
            }
            if valid.isNotNull(object: dictFinalAmount.object(forKey: "totalKm") as AnyObject){
                fare.totalKm = "\(dictFinalAmount.object(forKey: "totalKm") ?? "")"
            }
            
            
        }
        
        // Getting BaseFare Data from Object
        if valid.isNotNull(object: dictFare.object(forKey: "baseFare") as AnyObject){
            
            let dictbaseFare:NSDictionary = dictFare.object(forKey: "baseFare") as! NSDictionary
            
            if valid.isNotNull(object: dictbaseFare.object(forKey: "perKmAmount") as AnyObject){
                fare.perKmAmount = "\(dictbaseFare.object(forKey: "perKmAmount") ?? "")"
            }
            if valid.isNotNull(object: dictbaseFare.object(forKey: "totalFareAmount") as AnyObject){
                fare.totalFareAmount = "\(dictbaseFare.object(forKey: "totalFareAmount") ?? "")"
            }
        }
        
        // Getting ExtraKM Data from Object
        if valid.isNotNull(object: dictFare.object(forKey: "extraKm") as AnyObject){
            
            let dictExtraKm:NSDictionary = dictFare.object(forKey: "extraKm") as! NSDictionary
            
            if valid.isNotNull(object: dictExtraKm.object(forKey: "perKmPrice") as AnyObject){
                fare.perKmPrice = "\(dictExtraKm.object(forKey: "perKmPrice") ?? "")"
            }
            if valid.isNotNull(object: dictExtraKm.object(forKey: "totalExtraKm") as AnyObject){
                fare.totalExtraKm = "\(dictExtraKm.object(forKey: "totalExtraKm") ?? "")"
            }
        }
        
        // Getting TimeTaken Data from Object
        if valid.isNotNull(object: dictFare.object(forKey: "timeTaken") as AnyObject){
            
            let dictTimeTaken:NSDictionary = dictFare.object(forKey: "timeTaken") as! NSDictionary
            
            if valid.isNotNull(object: dictTimeTaken.object(forKey: "perMinFareAmount") as AnyObject){
                fare.perMinFareAmount = "\(dictTimeTaken.object(forKey: "perMinFareAmount") ?? "")"
            }
            if valid.isNotNull(object: dictTimeTaken.object(forKey: "totalTime") as AnyObject){
                fare.totalTime = "\(dictTimeTaken.object(forKey: "totalTime") ?? "")"
            }
        }
        
        
        
        if valid.isNotNull(object: dictFare.object(forKey: "carBrand") as AnyObject){
            fare.carBrand = "\(dictFare.object(forKey: "carBrand") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "carName") as AnyObject){
            fare.carName = "\(dictFare.object(forKey: "carName") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "carNumber") as AnyObject){
            fare.carNumber = "\(dictFare.object(forKey: "carNumber") ?? "")"
        }
    
        
        if valid.isNotNull(object: dictFare.object(forKey: "carTypeImage") as AnyObject){
            fare.carTypeImage = "\(dictFare.object(forKey: "carTypeImage") ?? "")"
        }
        
        if valid.isNotNull(object: dictFare.object(forKey: "carTypeName") as AnyObject){
            fare.carTypeName = "\(dictFare.object(forKey: "carTypeName") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLocation") as AnyObject){
            fare.dropOffLocation = "\(dictFare.object(forKey: "dropOffLocation") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLong") as AnyObject){
            fare.dropOffLong = "\(dictFare.object(forKey: "dropOffLong") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropoffLat") as AnyObject){
            fare.dropoffLat = "\(dictFare.object(forKey: "dropoffLat") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLocation") as AnyObject){
            fare.pickUpLocation = String(format:"%@",dictionary["pickUpLocation"] as! CVarArg)
        }
        
        
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLong") as AnyObject){
            fare.pickUpLong = "\(dictFare.object(forKey: "pickUpLong") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickupLat") as AnyObject){
            fare.pickupLat = "\(dictFare.object(forKey: "pickupLat") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "subCarTypeImage") as AnyObject){
            fare.subCarTypeImage = "\(dictFare.object(forKey: "subCarTypeImage") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "subCarTypeName") as AnyObject){
            fare.subCarTypeName = "\(dictFare.object(forKey: "subCarTypeName") ?? "")"
        }
        
        return fare
    }
    
    
}
