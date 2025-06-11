//
//  Country.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 15/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Country: YuppModel {
    public var country = ""
    public var countryCode = ""
    public var flagIcon = ""
    public var mobileCode = 0
    
    internal init(json: [String : Any]){
        super.init()
        country = getString(value: json["country"])
        countryCode = getString(value: json["countryCode"])
        flagIcon = getString(value: json["flagIcon"])
        mobileCode = getInt(value: json["mobileCode"])
    }
    
    public static func countriesList(json : Any?) -> [Country]{
        var list = [Country]()
        if let objJson = json as? [[String : Any]]{
            for obj in objJson {
                list.append(Country(json: obj))
            }
        }
        return list
    }

}
