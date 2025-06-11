//
//  Color+Font.swift
//  Luxongo
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//MARK:- Font
/*
Source Serif Pro
SourceSerifPro-Regular
SourceSerifPro-Bold
Source Serif Pro Semibold
SourceSerifPro-Semibold
*/
enum Font: String{
    enum Size: CGFloat{
        case small = 12
        case large = 20.0
    }
    
    case SourceSerifProRegular = "SourceSerifPro-Regular"
    case SourceSerifProBold = "SourceSerifPro-Bold"
    case SourceSerifProSemibold = "SourceSerifPro-Semibold"
    
    func size(_ size: Size) -> UIFont {
        return UIFont(name: self.rawValue, size: size.rawValue) ??
            UIFont.systemFont(ofSize: size.rawValue)
    }
    
    func size(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ??
            UIFont.systemFont(ofSize: size)
    }
    
}



//MARK:- Color


class Color: UIColor {
    //Ref from 'Material' -> TextField
    //Ex: detailColor = Color.darkText.others
    
    //For generate code base on hex code follow this link: http://uicolor.xyz/#/hex-to-ui
    
    class Orange {
        static let theme:UIColor = UIColor(red:(228/255), green:(197/255), blue:(128/255), alpha:1.0)
        static let lightOrange:UIColor = UIColor(red:(244/255), green:(228/255), blue:(193/255), alpha:1.0)//rgb 244 228 193
    }
    
    //Black
    class Black {
        static let textColor:UIColor = UIColor(red:(51/255), green:(51/255), blue:(51/255), alpha:1.0)
        static let tabSelected:UIColor = UIColor(red:(68/255), green:(68/255), blue:(68/255), alpha:1.0)
    }
    
    //Gray
    class grey {
        static let textColor:UIColor = UIColor(red: (102/255), green: (102/255), blue: (102/255), alpha: 1.00)
        //static let textLightColor:UIColor = UIColor(red: (153/255), green: (153/255), blue: (153/255), alpha: 0.85)
        static let textPlaceHolder:UIColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
        static let bgView:UIColor = UIColor(red: (245/255), green: (245/255), blue: (245/255), alpha: 1.00)
        static let textFieldTextClr:UIColor = UIColor(red: (153/255), green: (153/255), blue: (153/255), alpha: 1.00)
    }
    
    //Purpel
    class Purpel {
        static let textColor:UIColor = UIColor(red: (94/255), green: (84/255), blue: (166/255), alpha: 1.00)
    }

}


