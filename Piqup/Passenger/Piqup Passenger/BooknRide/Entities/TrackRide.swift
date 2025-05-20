//
//  TrackRide.swift
//  BooknRide
//
//  Created by KASP on 19/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class TrackRide: NSObject {

        var index = 0
        var status = false
        var stop  = false
        var driverLat = ""
        var driverLong = ""
        var passengerLat = ""
        var passengerLong = ""
        var carLat = ""
        var carLong = ""
        var pathString = ""
        var lastSendId = ""
        var timeLapse = ""
        var via = [NSDictionary]()
    
    
    class func initWithResponse(dictionary:[String:Any]?) -> TrackRide{
        
        guard let tempDict = dictionary else { return TrackRide() }
        
        let track = TrackRide()

        let valid = Validator()
        
        let dictTrack = tempDict as NSDictionary

        if valid.isNotNull(object: dictTrack.object(forKey: "index") as AnyObject){
            track.index = (dictTrack.object(forKey: "index")) as! Int
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "status") as AnyObject){
            track.status = (dictTrack.object(forKey: "status")) as! Bool
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "stop") as AnyObject){
            track.stop = (dictTrack.object(forKey: "stop")) as! Bool
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "driverLat") as AnyObject){
            track.driverLat = "\(dictTrack.object(forKey: "driverLat") ?? "")"
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "driverLong") as AnyObject){
            track.driverLong = "\(dictTrack.object(forKey: "driverLong") ?? "")"
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "passengerLat") as AnyObject){
            track.passengerLat = "\(dictTrack.object(forKey: "passengerLat") ?? "")"
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "passengerLong") as AnyObject){
            track.passengerLong = "\(dictTrack.object(forKey: "passengerLong") ?? "")"
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "carLat") as AnyObject){
            track.carLat = "\(dictTrack.object(forKey: "carLat") ?? "")"
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "carLong") as AnyObject){
            track.carLong = "\(dictTrack.object(forKey: "carLong") ?? "")"
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "pathString") as AnyObject){
            track.pathString = "\(dictTrack.object(forKey: "pathString") ?? "")"
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "lastSendId") as AnyObject){
            track.lastSendId = "\(dictTrack.object(forKey: "lastSendId") ?? "")"
        }
        if valid.isNotNull(object: dictTrack.object(forKey: "timeLapse") as AnyObject){
            track.timeLapse = "\(dictTrack.object(forKey: "timeLapse") ?? "")"
        }
    
        if (dictTrack.object(forKey: "via") != nil) {
            let viaArray = dictTrack.object(forKey: "via") as! NSArray
            
            track.via = [NSDictionary]()
            
            if viaArray.count>0 {
                
                for (_, element) in viaArray.enumerated() {
                    track.via.append(element as! NSDictionary)
                }
            }
        }
        
        return track
        
        }
}

class LocationModal : NSObject{

    var lat = ""
    var long = ""
    var distance = ""
}

