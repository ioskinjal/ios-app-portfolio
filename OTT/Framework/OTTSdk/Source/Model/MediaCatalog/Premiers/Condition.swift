//
//  Condition.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Condition: NSObject {
    public var title = ""
    public var conditionDescription = [String]()
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        title = Utility.getStringValue(value: json["title"])
        if let desc = json["description"] as? [String]{
            conditionDescription = desc
        }
    }
    
    public static func conditions(withJSON json: Any?) -> [Condition]{
        var list = [Condition]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Condition.init(withJSON: obj))
            }
        }
        return list
    }
}
