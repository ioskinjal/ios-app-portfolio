//
//  CustomColor.swift
//  Lifester
//
//  Created by NCT 24 on 06/12/17.
//  Copyright © 2017 NCT 24. All rights reserved.
//

import UIKit

class Color: UIColor {
    //Ref from 'Material' -> TextField
    //Ex: detailColor = Color.darkText.others
    
    //For generate code base on hex code follow this link: http://uicolor.xyz/#/hex-to-ui
    
    // dark text
    class darkText {
        static let primary = Color.black.withAlphaComponent(0.87)
        static let secondary = Color.black.withAlphaComponent(0.54)
        static let others = Color.black.withAlphaComponent(0.38)
        static let dividers = Color.black.withAlphaComponent(0.12)
    }
    
    // light text
    class lightText {
        static let primary = Color.white
        static let secondary = Color.white.withAlphaComponent(0.7)
        static let others = Color.white.withAlphaComponent(0.5)
        static let dividers = Color.white.withAlphaComponent(0.12)
    }
    
    //Black

    class Black {
        static let theam:UIColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        static let primary = UIColor.black
        static let secondaryColor:UIColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.7)
        static let otherColor:UIColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1.00)
    }
    
    //Pink
    class pink {
        static let dark = UIColor(red:0.76, green:0.01, blue:0.51, alpha:1.0)
        static let light = UIColor(red:0.99, green:0.22, blue:0.62, alpha:1.0)
    }
    
    //Green
    class green {
        static let theam = UIColor(red:0.30, green:0.69, blue:0.32, alpha:1.0)
        static let dark = UIColor(red:0.05, green:0.36, blue:0.13, alpha:1.0)
        static let light = UIColor(red:0.01, green:0.67, blue:0.18, alpha:1.0)
    }
    
    //Blue
    class blue {
        static let lightText = UIColor(red: 0.22, green: 0.45, blue: 0.84, alpha: 1.00)
    }
    
    //Orange
    class orange {
        //static let bgColor:UIColor = UIColor(red: 0.99, green: 0.40, blue: 0.01, alpha: 1.00)
        
    }
    
    //Red
    class red {
        static let lightText:UIColor = UIColor(red: 0.92, green: 0.14, blue: 0.16, alpha: 1.00)
    }
    
    //Gray
    class grey {
        static let light = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
        static let dark = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.0)
        static let lightText = UIColor(red:0.33, green:0.33, blue:0.33, alpha:1.0)
        
        static let textColor:UIColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)
        static let deviderColor:UIColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.00)
        static let lightDeviderColor:UIColor = UIColor(red: 0.01, green: 0.00, blue: 0.34, alpha: 0.1)
    }
    
    class Seprator {
         static let lightDeviderColor:UIColor = UIColor(hexString: "C5D4D7")
    }
    
}
