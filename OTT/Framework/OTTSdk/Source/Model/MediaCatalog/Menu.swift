//
//  Menu.swift
//  YuppTV
//
//  Created by Muzaffar on 12/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Menu: NSObject {
    
    public var title = ""
    public var code = ""
    public var dataType = ""
    public var showTimeControl = false
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        title = Utility.getStringValue(value: json["title"])
        code = Utility.getStringValue(value: json["code"])
        dataType = Utility.getStringValue(value: json["dataType"])
        showTimeControl = Utility.getBoolValue(value: json["showTimeControl"])
    }
    
    public static func menuList(json : [[String : Any]]) -> [Menu]{
        var list = [Menu]()
        for obj in json {
            list.append(Menu.init(withJSON: obj))
        }
        return list
    }
    
}
