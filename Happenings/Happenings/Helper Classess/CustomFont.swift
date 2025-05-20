//
//  CustomFont.swift
//  Lifester
//
//  Created by NCT 24 on 06/12/17.
//  Copyright © 2017 NCT 24. All rights reserved.
//

import UIKit

public protocol FontType {}

public enum FontSize:CGFloat {
    case small = 15.0
    case medium = 17.0
    case large = 36.0
}

public struct TitilliumWebFont: FontType {
    //Ref from 'Material' -> TextField
    //Ex: detailLabel.font = RobotoFont.regular(with: 12)
    
    static let semiBold = "TitilliumWeb-SemiBold"
    static let medium = "Roboto-Medium"
    static let regularFont = "TitilliumWeb-Regular"
   
    
    /// Size of font.
    public static var pointSize: CGFloat {
        return Font.pointSize
    }
    
    /// Thin font.
//    public static var thin: UIFont {
//        return thin(with: Font.pointSize)
//    }
    
    /// Light font.
//    public static var light: UIFont {
//        return light(with: Font.pointSize)
//    }
    
    /// Regular font.
    public static var regular: UIFont {
        return regular(with: Font.pointSize)
    }
    
    /// Medium font.
  
    
    /// Bold font.
//    public static var bold: UIFont {
//        return bold(with: Font.pointSize)
//    }

    /// Thin font.
   
    
    /**
     Thin with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    
    
    /**
     Light with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
//    public static func light(with size: CGFloat) -> UIFont {
//
//        if let f = UIFont(name: lightFontName, size: size) {
//            return f
//        }
//
//        return Font.systemFont(ofSize: size)
//    }
    
    /**
     Regular with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func regular(with size: CGFloat) -> UIFont {
        
        if let f = UIFont(name: regularFont, size: size) {
            return f
        }
        
        return Font.systemFont(ofSize: size)
    }
    
    public static func medium(with size: CGFloat) -> UIFont {
        
        if let f = UIFont(name: medium, size: size) {
            return f
        }
        
        return Font.systemFont(ofSize: size)
    }
    
    /**
     Medium with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
   
    
    /**
     Bold with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func semiBold(with size: CGFloat) -> UIFont {

        if let f = UIFont(name: semiBold, size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }
    
    /**
     SemiBold with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
//    public static func semibold(with size: CGFloat) -> UIFont {
//
//        if let f = UIFont(name: semiboldFontName, size: size) {
//            return f
//        }
//
//        return Font.boldSystemFont(ofSize: size)
//    }
    

}

public struct Font {
    /// Size of font.
    public static let pointSize: CGFloat = 17
    
    /**
     Retrieves the system font with a specified size.
     - Parameter ofSize size: A CGFloat.
     */
    public static func systemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    /**
     Retrieves the bold system font with a specified size..
     - Parameter ofSize size: A CGFloat.
     */
    public static func boldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    /**
     Retrieves the italic system font with a specified size.
     - Parameter ofSize size: A CGFloat.
     */
    public static func italicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize: size)
    }
    
}

