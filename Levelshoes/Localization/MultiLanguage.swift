//
//  MultiLanguage.swift
//  Luxongo
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//MARK:- MultiLanguage

enum MuliLanguage:String{
    case english = "English"
    //    case french = "French"
    //    case portuguese = "Portuguese"
    case arabic = "Arabic"
}

enum MuliLangShortHand:String{
    case en = "en"
    //    case fr = "fr"
    //    case pt = "pt-PT"
    case ar = "ar"
    case base = "Base" //Defaull string file
}

extension Bundle{
    static func localizedString(languageType type: MuliLangShortHand, forKey key: String, value: String? = nil, table tableName: String? = nil) -> String{
        let path = self.main.path(forResource: type.rawValue, ofType: "lproj")!
        let bundal = Bundle(path: path)!
        return bundal.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension String {
    var localized: String {
        //return Bundle().localizedString(forKey: self, value: nil, table: nil)
        
        if UserDefaults.standard.value(forKey: string.userLanguage) == nil {
            return Bundle.localizedString(languageType: .en, forKey: self)
        }
        else{
           
             let userLanguage = UserDefaults.standard.value(forKey: string.userLanguage) as! String
        
            
            //            if userLanguage.caseInsensitiveCompare(string: MuliLanguage.french.rawValue){
            //                //print("Value:\(Bundle.localizedString(languageType: .fr, forKey: self))")
            //                return Bundle.localizedString(languageType: .fr, forKey: self)
            //            }
            //            else if userLanguage.caseInsensitiveCompare(string: MuliLanguage.portuguese.rawValue){
            //                //print("Value:\(Bundle.localizedString(languageType: .pt, forKey: self))")
            //                return Bundle.localizedString(languageType: .pt, forKey: self)
            //            }
            
            if userLanguage.caseInsensitiveCompare(string: MuliLanguage.arabic.rawValue){
                //print("Value:\(Bundle.localizedString(languageType: .fr, forKey: self))")
                return Bundle.localizedString(languageType: .ar, forKey: self)
            }
            else if userLanguage.caseInsensitiveCompare(string: MuliLanguage.english.rawValue){
                //print("Value:\(Bundle.localizedString(languageType: .en, forKey: self))")
                return Bundle.localizedString(languageType: .en, forKey: self)
            }
            else{
                //print("Value:\(Bundle.localizedString(languageType: .base, forKey: self))")
                return Bundle.localizedString(languageType: .base, forKey: self)
            }
        }
    }
}

