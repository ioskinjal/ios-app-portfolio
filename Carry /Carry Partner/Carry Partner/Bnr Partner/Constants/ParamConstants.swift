//
//  ParamConstants.swift
//  BooknRide
//
//  Created by KASP on 28/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class ParamConstants: NSObject {

    public struct Currency{
        
        static let currentValue = "$"
    }
    
    public struct Defaults{
        
        static let isOnline = "isOnline"
        static let isUnderRide = "isUnderRide"
        static let isRideAccepted = "isRideAccepted"
        static let isRideStarted = "isRideStarted"
        static let rideId = "rideId"
        static let carId = "carId"
    }
    
    public struct Google{
        
        static let mapKey = "AIzaSyAozbCZgRrbgHo4dJPYlecWr1DQSvPUhC4"
        static let placeKey = "AIzaSyDaIT6ku5CuDIUaPDLMEHDQ4N5f5BZRRMk"
        static let clientID = "659528866921-nh6rbib5kdgs8mio7jtgb6mctjbakbaq.apps.googleusercontent.com"
        
    }
    
}
