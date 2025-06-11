//
//  Term.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit
///static content information
public class Term: NSObject {
    public var title = ""
    public var icon = ""
    public var conditions = [Condition]()
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        title = Utility.getStringValue(value: json["title"])
        icon = Utility.getStringValue(value: json["icon"])
        conditions = Condition.conditions(withJSON: json["conditions"])
    }
    
    
    public static func terms(withJSON json: Any?) -> [Term]{
        var list = [Term]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Term.init(withJSON: obj))
            }
        }
        return list
    }
}
