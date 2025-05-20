//
//  Rides.swift
//  BooknRide
//
//  Created by NCrypted Technologies on 11/13/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class Rides: NSObject {

    var brandName = ""
    var carName = ""
    var createdDateTime = ""
    var driverFirstName = ""
    var driverId = ""
    var driverLastName = ""
    var driverProfileImage = ""
    var dropOffLat = ""
    var dropOffLocation = ""
    var dropOffLong = ""
    var pickUpLat = ""
    var pickUpLocation = ""
    var pickUpLong = ""
    var rejectedBy = ""
    var rideId = ""
    var status = ""
    var subTypeImage = ""
    var subTypeName = ""
    var typeImage = ""
    var typeName = ""
    var userFirstName = ""
    var userLastName = ""
    
    
    override init() {
        
    }
    
    class func initWithResponse(array:[Any]?) -> [Any]{
        
        var allCodes = [Rides]()
        
        
        guard let tempArray = array else { return [Rides]() }
        
        
        let valid = Validator()
        
        for case let item as NSDictionary in tempArray {
            
            let code = Rides()
            
            
            if valid.isNotNull(object: item.object(forKey: "brandName") as AnyObject){
                code.brandName = String(format:"%@",item.object(forKey: "brandName") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "carName") as AnyObject){
                code.carName = String(format:"%@",item.object(forKey: "carName") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "createdDateTime") as AnyObject){
                code.createdDateTime = String(format:"%@",item.object(forKey: "createdDateTime") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "driverFirstName") as AnyObject){
                code.driverFirstName = String(format:"%@",item.object(forKey: "driverFirstName") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "driverId") as AnyObject){
                code.driverId = String(format:"%@",item.object(forKey: "driverId") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "driverLastName") as AnyObject){
                code.driverLastName = String(format:"%@",item.object(forKey: "driverLastName") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "driverProfileImage") as AnyObject){
                code.driverProfileImage = String(format:"%@",item.object(forKey: "driverProfileImage") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "dropOffLat") as AnyObject){
                code.dropOffLat = String(format:"%@",item.object(forKey: "dropOffLat") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "dropOffLocation") as AnyObject){
                code.dropOffLocation = String(format:"%@",item.object(forKey: "dropOffLocation") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "dropOffLong") as AnyObject){
                code.dropOffLong = String(format:"%@",item.object(forKey: "dropOffLong") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "pickUpLat") as AnyObject){
                code.pickUpLat = String(format:"%@",item.object(forKey: "pickUpLat") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "pickUpLocation") as AnyObject){
                code.pickUpLocation = String(format:"%@",item.object(forKey: "pickUpLocation") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "pickUpLong") as AnyObject){
                code.pickUpLong = String(format:"%@",item.object(forKey: "pickUpLong") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "rejectedBy") as AnyObject){
                code.rejectedBy = String(format:"%@",item.object(forKey: "rejectedBy") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "rideId") as AnyObject){
                code.rideId = String(format:"%@",item.object(forKey: "rideId") as! CVarArg)
            }
            if valid.isNotNull(object: item.object(forKey: "status") as AnyObject){
                code.status = String(format:"%@",item.object(forKey: "status") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "subTypeImage") as AnyObject){
                code.subTypeImage = String(format:"%@",item.object(forKey: "subTypeImage") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "subTypeName") as AnyObject){
                code.subTypeName = String(format:"%@",item.object(forKey: "subTypeName") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "typeImage") as AnyObject){
                code.typeImage = String(format:"%@",item.object(forKey: "typeImage") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "typeName") as AnyObject){
                code.typeName = String(format:"%@",item.object(forKey: "typeName") as! NSString)
            }
            
            if valid.isNotNull(object: item.object(forKey: "userFirstName") as AnyObject){
                code.userFirstName = String(format:"%@",item.object(forKey: "userFirstName") as! NSString)
            }
            if valid.isNotNull(object: item.object(forKey: "userLastName") as AnyObject){
                code.userLastName = String(format:"%@",item.object(forKey: "userLastName") as! NSString)
            }
            
            
            allCodes.append(code)
            
        }
        
        
        return allCodes
    }
    
}

class RideTripDetails : NSObject{
    
    var avgRatting = ""
    var brandName = ""
    var carName = ""
    var carNumber = ""
    var driverCountryCode = ""
    var driverFirstName = ""
    var driverId = ""
    var driverLastName = ""
    var driverProfileImage = ""
    var dropOffLat = ""
    var dropOffLocation = ""
    var dropOffLong = ""
    var extraDistance = ""
    var fareAdditionalCharges = ""
    var fareAdditionalChargesPerKm = ""
    var fareAdditionalKm = ""
    var fareDistance = ""
    var fareDistanceCharges = ""
    var fareTime = ""
    var fareTimeCharges = ""
    var feedback = ""
    var mobileNo = ""
    var payByCash = ""
    var payByWallet = ""
    var perMinCharges = ""
    var pickUpLat = ""
    var pickUpLocation = ""
    var pickUpLong = ""
    var rating = "0"
    var rideDateTime = ""
    var rideId = ""
    var status = ""
    var subTypeImage = ""
    var subTypeName = ""
    var totalCharges = ""
    var totalDistance = ""
    var totalExtraCharges = ""
    var totalFareCharges = ""
    var totalRating = ""
    var totalTime = ""
    var totalTimeCharges = ""
    var typeImage = ""
    var typeName = ""
    var userFirstName = ""
    var userMobileNo = ""
    var userPanicNo = ""
    var userProfileImage = ""
    var userlastName = ""

    
    override init() {
        
    }
    
    class func initWithResponse(dictionary:[String:Any]?) -> RideTripDetails {
        guard let dictionary = dictionary else { return RideTripDetails() }
        
        let fare = RideTripDetails()
        
        let valid = Validator()
        
        let dictFare = dictionary as NSDictionary
        
        if valid.isNotNull(object: dictFare.object(forKey: "avgRatting") as AnyObject){
            fare.avgRatting = "\(dictFare.object(forKey: "avgRatting") ?? "")"
        }
        
        if valid.isNotNull(object: dictFare.object(forKey: "brandName") as AnyObject){
            fare.brandName = String(format:"%@",dictFare.object(forKey: "brandName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "carName") as AnyObject){
            fare.carName = String(format:"%@",dictFare.object(forKey: "carName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "carNumber") as AnyObject){
            fare.carNumber = String(format:"%@",dictFare.object(forKey: "carNumber") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverCountryCode") as AnyObject){
            fare.driverCountryCode = String(format:"%@",dictFare.object(forKey: "driverCountryCode") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverFirstName") as AnyObject){
            fare.driverFirstName = String(format:"%@",dictFare.object(forKey: "driverFirstName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverId") as AnyObject){
            fare.driverId = String(format:"%@",dictFare.object(forKey: "driverId") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverLastName") as AnyObject){
            fare.driverLastName = String(format:"%@",dictFare.object(forKey: "driverLastName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverProfileImage") as AnyObject){
            fare.driverProfileImage = String(format:"%@",dictFare.object(forKey: "driverProfileImage") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLat") as AnyObject){
            fare.dropOffLat = String(format:"%@",dictFare.object(forKey: "dropOffLat") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLocation") as AnyObject){
            fare.dropOffLocation = String(format:"%@",dictFare.object(forKey: "dropOffLocation") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLong") as AnyObject){
            fare.dropOffLong = String(format:"%@",dictFare.object(forKey: "dropOffLong") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "extraDistance") as AnyObject){
            fare.extraDistance = "\(dictFare.object(forKey: "extraDistance") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareAdditionalCharges") as AnyObject){
            fare.fareAdditionalCharges = String(format:"%f",dictFare.object(forKey: "fareAdditionalCharges") as! Float)

        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareAdditionalChargesPerKm") as AnyObject){
            fare.fareAdditionalChargesPerKm = String(format:"%@",dictFare.object(forKey: "fareAdditionalChargesPerKm") as! CVarArg)
            
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareAdditionalKm") as AnyObject){
            fare.fareAdditionalKm = String(format:"%@",dictFare.object(forKey: "fareAdditionalKm") as! NSString)
            
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareDistance") as AnyObject){
            fare.fareDistance = String(format:"%@",dictFare.object(forKey: "fareDistance") as! NSString)
            
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareDistanceCharges") as AnyObject){
            fare.fareDistanceCharges = String(format:"%f",dictFare.object(forKey: "fareDistanceCharges") as! Float)
        }
        
        if valid.isNotNull(object: dictFare.object(forKey: "fareTime") as AnyObject){
            fare.fareTime = String(format:"%@",dictFare.object(forKey: "fareTime") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "fareTimeCharges") as AnyObject){
            fare.fareTimeCharges = String(format:"%d",dictFare.object(forKey: "fareTimeCharges") as! Int)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "feedback") as AnyObject){
            fare.feedback = String(format:"%@",dictFare.object(forKey: "feedback") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "mobileNo") as AnyObject){
            fare.mobileNo = String(format:"%@",dictFare.object(forKey: "mobileNo") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "payByCash") as AnyObject){
            fare.payByCash = String(format:"%d",dictFare.object(forKey: "payByCash") as! Int)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "payByWallet") as AnyObject){
            fare.payByWallet = String(format:"%d",dictFare.object(forKey: "payByWallet") as! Int)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "perMinCharges") as AnyObject){
            fare.perMinCharges = "\(dictFare.object(forKey: "perMinCharges") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLat") as AnyObject){
            fare.pickUpLat = String(format:"%@",dictFare.object(forKey: "pickUpLat") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLocation") as AnyObject){
            fare.pickUpLocation = String(format:"%@",dictFare.object(forKey: "pickUpLocation") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLong") as AnyObject){
            fare.pickUpLong = String(format:"%@",dictFare.object(forKey: "pickUpLong") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "rating") as AnyObject){
            fare.rating = "\(dictFare.object(forKey: "rating") ?? "0")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "rideDateTime") as AnyObject){
            fare.rideDateTime = String(format:"%@",dictFare.object(forKey: "rideDateTime") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "rideId") as AnyObject){
            fare.rideId = "\(dictFare.object(forKey: "rideId") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "status") as AnyObject){
            fare.status = String(format:"%@",dictFare.object(forKey: "status") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "subTypeImage") as AnyObject){
            fare.subTypeImage = String(format:"%@",dictFare.object(forKey: "subTypeImage") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "subTypeName") as AnyObject){
            fare.subTypeName = String(format:"%@",dictFare.object(forKey: "subTypeName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalCharges") as AnyObject){
            fare.totalCharges = String(format:"%d",dictFare.object(forKey: "totalCharges") as! Int)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalDistance") as AnyObject){
            fare.totalDistance = String(format:"%@",dictFare.object(forKey: "totalDistance") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalExtraCharges") as AnyObject){
            fare.totalExtraCharges = String(format:"%d",dictFare.object(forKey: "totalExtraCharges") as! Int)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalFareCharges") as AnyObject){
            fare.totalFareCharges = "\(dictFare.object(forKey: "totalFareCharges") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalRating") as AnyObject){
            fare.totalRating = "\(dictFare.object(forKey: "totalRating") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalTime") as AnyObject){
            fare.totalTime = "\(dictFare.object(forKey: "totalTime") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalTimeCharges") as AnyObject){
            fare.totalTimeCharges = String(format:"%d",dictFare.object(forKey: "totalTimeCharges") as! Int)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "typeImage") as AnyObject){
            fare.typeImage = String(format:"%@",dictFare.object(forKey: "typeImage") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "typeName") as AnyObject){
            fare.typeName = String(format:"%@",dictFare.object(forKey: "typeName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "userFirstName") as AnyObject){
            fare.userFirstName = String(format:"%@",dictFare.object(forKey: "userFirstName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "userMobileNo") as AnyObject){
            fare.userMobileNo = String(format:"%@",dictFare.object(forKey: "userMobileNo") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "userPanicNo") as AnyObject){
            fare.userPanicNo = String(format:"%@",dictFare.object(forKey: "userPanicNo") as! NSString)
        }
 
        
        
        if valid.isNotNull(object: dictFare.object(forKey: "userProfileImage") as AnyObject){
            fare.userProfileImage = String(format:"%@",dictFare.object(forKey: "userProfileImage") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "userlastName") as AnyObject){
            fare.userlastName = String(format:"%@",dictFare.object(forKey: "userlastName") as! NSString)
        }
        
        return fare
        
        
    }
    
    
}

class RideInfo : NSObject{
    
    var avgRatting = ""
    var brandName = ""
    var carName = ""
    var carNumber = ""
    var driverArrivelTime = ""
    var driverContact = ""
    var driverId = ""
    var driverLastLat = ""
    var driverLastLong = ""
    var driverName = ""
    var driverProfileImage = ""
    var dropOffLat = ""
    var dropOffLocation = ""
    var dropOffLong = ""
    var extraFareKm = ""
    var extraFareKmRate = ""
    var isLongRide = ""
    var isUrgent = ""
    var minFareKm = ""
    var minFareKmRate = ""
    var pathString = ""
    var perMinRate = ""
    var pickUpLat = ""
    var pickUpLocation = ""
    var pickUpLong = ""
    var rideDateTime = ""
    var status = ""
    var subTypeImage = ""
    var subTypeName = ""
    var totalRatting = ""
    var typeImage = ""
    var typeName = ""
    
    override init() {
        
    }
    
    class func initWithResponse(dictionary:[String:Any]?) -> RideInfo {
        guard let dictionary = dictionary else { return RideInfo() }
        
        let fare = RideInfo()
        
        let valid = Validator()
        
        let dictFare = dictionary as NSDictionary
        
        if valid.isNotNull(object: dictFare.object(forKey: "avgRatting") as AnyObject){
            fare.avgRatting = "\(dictFare.object(forKey: "avgRatting") ?? "")"
        }
        
        if valid.isNotNull(object: dictFare.object(forKey: "brandName") as AnyObject){
            fare.brandName = String(format:"%@",dictFare.object(forKey: "brandName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "carName") as AnyObject){
            fare.carName = String(format:"%@",dictFare.object(forKey: "carName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "carNumber") as AnyObject){
            fare.carNumber = String(format:"%@",dictFare.object(forKey: "carNumber") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverArrivelTime") as AnyObject){
            fare.driverArrivelTime = String(format:"%@",dictFare.object(forKey: "driverArrivelTime") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverContact") as AnyObject){
            fare.driverContact = String(format:"%@",dictFare.object(forKey: "driverContact") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverId") as AnyObject){
            fare.driverId = "\(dictFare.object(forKey: "driverId") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverLastLat") as AnyObject){
            fare.driverLastLat = String(format:"%@",dictFare.object(forKey: "driverLastLat") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverLastLong") as AnyObject){
            fare.driverLastLong = String(format:"%@",dictFare.object(forKey: "driverLastLong") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverName") as AnyObject){
            fare.driverName = String(format:"%@",dictFare.object(forKey: "driverName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "driverProfileImage") as AnyObject){
            fare.driverProfileImage = String(format:"%@",dictFare.object(forKey: "driverProfileImage") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLat") as AnyObject){
            fare.dropOffLat = String(format:"%@",dictFare.object(forKey: "dropOffLat") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLocation") as AnyObject){
            fare.dropOffLocation = "\(dictFare.object(forKey: "dropOffLocation") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "dropOffLong") as AnyObject){
            fare.dropOffLong = "\(dictFare.object(forKey: "dropOffLong") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "extraFareKm") as AnyObject){
            fare.extraFareKm = "\(dictFare.object(forKey: "extraFareKm") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "extraFareKmRate") as AnyObject){
            fare.extraFareKmRate = "\(dictFare.object(forKey: "extraFareKmRate") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "isLongRide") as AnyObject){
            fare.isLongRide = "\(dictFare.object(forKey: "isLongRide") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "isUrgent") as AnyObject){
            fare.isUrgent = "\(dictFare.object(forKey: "isUrgent") ?? "")"
        }
        
        if valid.isNotNull(object: dictFare.object(forKey: "minFareKm") as AnyObject){
            fare.minFareKm = "\(dictFare.object(forKey: "minFareKm") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "minFareKmRate") as AnyObject){
            fare.minFareKmRate = "\(dictFare.object(forKey: "minFareKmRate") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pathString") as AnyObject){
            fare.pathString = String(format:"%@",dictFare.object(forKey: "pathString") as! NSString)
        }

        if valid.isNotNull(object: dictFare.object(forKey: "perMinRate") as AnyObject){
            fare.perMinRate = "\(dictFare.object(forKey: "perMinRate") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLat") as AnyObject){
            fare.pickUpLat = String(format:"%@",dictFare.object(forKey: "pickUpLat") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLocation") as AnyObject){
            fare.pickUpLocation = String(format:"%@",dictFare.object(forKey: "pickUpLocation") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "pickUpLong") as AnyObject){
            fare.pickUpLong = String(format:"%@",dictFare.object(forKey: "pickUpLong") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "rideDateTime") as AnyObject){
            fare.rideDateTime = String(format:"%@",dictFare.object(forKey: "rideDateTime") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "status") as AnyObject){
            fare.status = String(format:"%@",dictFare.object(forKey: "status") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "subTypeImage") as AnyObject){
            fare.subTypeImage = String(format:"%@",dictFare.object(forKey: "subTypeImage") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "subTypeName") as AnyObject){
            fare.subTypeName = String(format:"%@",dictFare.object(forKey: "subTypeName") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "totalRatting") as AnyObject){
            fare.totalRatting = "\(dictFare.object(forKey: "totalRatting") ?? "")"
        }
        if valid.isNotNull(object: dictFare.object(forKey: "typeImage") as AnyObject){
            fare.typeImage = String(format:"%@",dictFare.object(forKey: "typeImage") as! NSString)
        }
        if valid.isNotNull(object: dictFare.object(forKey: "typeName") as AnyObject){
            fare.typeName = String(format:"%@",dictFare.object(forKey: "typeName") as! NSString)
        }
        
        return fare
        
        
    }
    
    
}

