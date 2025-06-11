//
//  Localization.swift
//  OTT
//
//  Created by Muzaffar on 25/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

class Localization: NSObject {
    
    var bundle : Bundle?
    
    static var instance : Localization{
        struct Singleton{
            static let object = Localization()
        }
        return Singleton.object
    }
    
    func updateLocalization() {
        //pt
        let resource = OTTSdk.preferenceManager.selectedDisplayLanguage == "POT" ? "pt-BR" : "en"
        let bundlePath = Bundle.main.path(forResource: resource,ofType: "lproj")
        bundle = Bundle.init(path: bundlePath!)
    }
}

extension String {
    var localized: String {
        if let value = (Localization.instance.bundle?.localizedString(forKey: self, value: nil, table: nil)){
            return value
        }
        else{
            return self
        }
    }
}
