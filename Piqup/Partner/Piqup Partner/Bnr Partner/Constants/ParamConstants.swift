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
        
      //  static let mapKey = "AIzaSyAozbCZgRrbgHo4dJPYlecWr1DQSvPUhC4"
      //  static let placeKey = "AIzaSyDaIT6ku5CuDIUaPDLMEHDQ4N5f5BZRRMk"
        static let mapKey = "AIzaSyAozbCZgRrbgHo4dJPYlecWr1DQSvPUhC4"
         static let placeKey = "AIzaSyC6TiE766bT2mlhddql775KYQd7lqnp7QQ"
        
        static let clientID = "873253299212-r2b6tu12bsqur5hiai8hoj7atbgqrbob.apps.googleusercontent.com"
        
    }
    
}
