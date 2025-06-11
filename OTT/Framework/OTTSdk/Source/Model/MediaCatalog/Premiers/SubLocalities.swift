//
//  SubLocalities.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class SubLocalities: NSObject {
    public var name = ""
    public var icon = ""
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        name = Utility.getStringValue(value: json["name"])
        icon = Utility.getStringValue(value: json["icon"])
    }
    
    public static func subLocalities(withJSON json: Any?) -> [SubLocalities]{
        var list = [SubLocalities]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(SubLocalities.init(withJSON: obj))
            }
        }
        return list
    }
}
