//
//  Extension+UIFont.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension UIFont {
    class func getAllFontName() {
        for family in UIFont.familyNames {
            let familyString = family as NSString
            print("=============\(familyString)==============")
            for name in UIFont.fontNames(forFamilyName: familyString as String) {
                print(name)
            }
        }
    }
    class func printAllFontNames() {
        UIFont.familyNames.sorted().forEach({ print("=======\($0)======="); UIFont.fontNames(forFamilyName: $0 as String).forEach({print($0)})})
    }
}
