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
    case dutch = "Dutch"
}

enum MuliLangShortHand:String{
    case en = "en"
    //    case fr = "fr"
    //    case pt = "pt-PT"
    case dt = "nl"
    case base = "Base" //Defaull string file
}

extension Bundle{
    static func localizedString(languageType type: MuliLangShortHand, forKey key: String, value: String? = nil, table tableName: String? = nil) -> String{
        if let path = self.main.path(forResource: type.rawValue, ofType: "lproj"), let bundal = Bundle(path: path){
            return bundal.localizedString(forKey: key, value: value, table: tableName)
        }else{
            return key
        }
    }
}

//MARK: String
extension String {
    var localized: String {
        if self.trimmingCharacters(in: .whitespaces) == ""{ return self }
        let currentLang = UserData.shared.appLanguage
        return Bundle.localizedString(languageType: currentLang, forKey: self)
    }
}

//MARK: UserData
extension UserData{
    var isRTL: Bool{
        //TODO: set RTL Languages here only!!
        let rtlLang:[MuliLangShortHand] = []
        return rtlLang.contains(self.appLanguage)
    }
    
    //TODO: Add new language is here only!!
    var appLanguage: MuliLangShortHand {
        let userLanguage = UserData.shared.languageID
        if userLanguage.caseInsensitiveCompare(string: MuliLanguage.dutch.rawValue){
            return .dt
        }
        else if userLanguage.caseInsensitiveCompare(string: MuliLanguage.english.rawValue){
            return .en
        }
        else{ return .base }
    }
    
    func setLanguageDirestion() {
        UIView.appearance().semanticContentAttribute = ( self.isRTL ? .forceRightToLeft : .forceLeftToRight )
    }
}
