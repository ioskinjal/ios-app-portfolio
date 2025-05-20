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
        
        static let rideId = "rideId"
        static let carId = "carId"
    }
    
    public struct Google{
        
       // static let mapKey = "AIzaSyBtcqv3-r5P_1MwBMFX_baVLaCWKeZ8XT4"
        static let mapKey = "AIzaSyAnOLPiqFgJXL5GIMUs6NWtrWXqDhZ2CKw"
        
        static let placeKey = "AIzaSyBzp9NSiLrZyoyKEn6ub_1jWgkfwQFfhYA"
        static let clientID = "873253299212-4a9oabtsl7f55730vlqo58ssbp4mmtmd.apps.googleusercontent.com"
        
        
    }
}


extension UICollectionViewCell
{
    class var identifier:String
    {
        return"\(self)"
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
