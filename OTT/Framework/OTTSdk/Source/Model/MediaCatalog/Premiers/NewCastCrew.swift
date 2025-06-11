//
//  NewCastCrew.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class NewCastCrew: NSObject {
    public var name = ""
    public var code = ""
    public var iconUrl = ""
    public var role = ""
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        name = Utility.getStringValue(value: json["name"])
        code = Utility.getStringValue(value: json["code"])
        iconUrl = Utility.getStringValue(value: json["iconUrl"])
        role = Utility.getStringValue(value: json["role"])
    }
    
    internal static func newCastCrewList(withJSON json: Any?) -> [NewCastCrew]{
        var list = [NewCastCrew]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(NewCastCrew.init(withJSON: obj))
            }
        }
        return list
    }
}
