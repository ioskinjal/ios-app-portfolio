//
//  Localities.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Localities: NSObject {
    public var name = ""
    public var localitiesDescription = ""
    public var subLocalities = [SubLocalities]()
    
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        name = Utility.getStringValue(value: json["name"])
        localitiesDescription = Utility.getStringValue(value: json["description"])
        subLocalities = SubLocalities.subLocalities(withJSON: json["subLocalities"])
    }
    
    public static func localities(withJSON json: Any?) -> [Localities]{
        var list = [Localities]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Localities.init(withJSON: obj))
            }
        }
        return list
    }
}
