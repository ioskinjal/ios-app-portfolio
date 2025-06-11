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

public struct BrandenFont: FontType {
    //Ref from 'Material' -> TextField
    //Ex: detailLabel.font = RobotoFont.regular(with: 12)
    
    static let blackFont = "BrandonGrotesque-Black"
    static let boldItalicFont = "BrandonGrotesque-BoldItalic"
    static let boldFont = "BrandonGrotesque-Bold"
    static let lightItalicFont = "BrandonGrotesque-Light"
    static let mediumItalicFont = "BrandonGrotesque-MediumItalic"
    static let mediumFont = "BrandonGrotesque-Medium"
    static let lightFont = "BrandonGrotesque-Light"
    static let regularItalicFont = "BrandonGrotesque-RegularItalic"
    static let regularFont = "BrandonGrotesque-Regular"
    static let thinItalicFont = "BrandonGrotesque-ThinItalic"
    
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
    public static var medium: UIFont {
        return medium(with: Font.pointSize)
    }
    
    /// Bold font.
    public static var bold: UIFont {
        return bold(with: Font.pointSize)
    }

    /// Thin font.
    public static var thin: UIFont {
        return thin(with: Font.pointSize)
    }
    
    //Black
    public static var black: UIFont {
        return black(with: Font.pointSize)
    }
    
    /**
     Thin with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func thin(with size: CGFloat) -> UIFont {

        if let f = UIFont(name: lightFont, size: size) {
            return f
        }

        return Font.systemFont(ofSize: size)
    }
    
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
    
    /**
     Medium with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func mediumItalic(with size: CGFloat) -> UIFont {

        if let f = UIFont(name: mediumItalicFont, size: size) {
            return f
        }

        return Font.systemFont(ofSize: size)
    }
    
    public static func medium(with size: CGFloat) -> UIFont {

        if let f = UIFont(name: mediumFont, size: size) {
            return f
        }

        return Font.systemFont(ofSize: size)
    }
    
    /**
     Bold with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func bold(with size: CGFloat) -> UIFont {

        if let f = UIFont(name: boldFont, size: size) {
            return f
        }

        return Font.boldSystemFont(ofSize: size)
    }
    
    public static func black(with size: CGFloat) -> UIFont {

        if let f = UIFont(name: blackFont, size: size) {
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

