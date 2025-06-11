//
//  Country.swift
//  OTTSdk
//
//  Created by Muzaffar on 12/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Country: YuppModel{
    @objc public var code = ""
    public var name = ""
    public var isdCode = 0
    public var iconUrl = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        code = getString(value: json["code"])
        name = getString(value:json["name"])
        isdCode = getInt(value:json["isdCode"])
        iconUrl = getImageUrl(value: json["iconUrl"])
    }
    
    public static func array(json : Any?) -> [Country]{
        var list = [Country]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Country(obj))
            }
        }
        return list
    }
}
