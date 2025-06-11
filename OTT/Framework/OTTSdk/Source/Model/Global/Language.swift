//
//  Language.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 16/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Language: NSObject {
    public var code = ""
    public var hdImage = ""
    public var name = ""
    public var selectedHdImage = ""
    
    internal init(withJson json: [String : Any]){
        super.init()
        code = Utility.getStringValue(value: json["code"])
        hdImage = Utility.getStringValue(value: json["hdImage"])
        name = Utility.getStringValue(value: json["name"])
        selectedHdImage = Utility.getStringValue(value: json["selectedHdImage"])
    }
    
    public static func languagesList(json : Any?) -> [Language]{
        var list = [Language]()
        if let objJson = json as? [[String : Any]]{
            for obj in objJson {
                list.append(Language.init(withJson: obj))
            }
        }
        return list
    }
}
