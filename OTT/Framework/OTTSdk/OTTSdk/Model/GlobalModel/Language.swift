//
//  Language.swift
//  OTTSdk
//
//  Created by Muzaffar on 12/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Language: YuppModel {
    public var code = ""
    public var name = ""

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        code = getString(value: json["code"])
        name = getString(value:json["name"])
    }
    
    public static func array(json : Any?) -> [Language]{
        var list = [Language]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Language(obj))
            }
        }
        return list
    }
}
