//
//  Colors.swift
//  BooknRide
//
//  Created by KASP on 27/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class Colors: NSObject {

    
    
    public func appThemeYellow() -> UIColor {
       return UIColor.init(red: 248, green: 199, blue: 73)
    }
        
    
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
