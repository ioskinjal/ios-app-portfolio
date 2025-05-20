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
