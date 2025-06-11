//
//  Banner.swift
//  OTTSdk
//
//  Created by Muzaffar on 04/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Banner: YuppModel {
    
    
    public struct Target {
        public var path = ""
    }
    
    public var subtitle = ""
    public var isInternal = false
    public var buttonText = ""
    public var code = ""
    public var id = 0
    public var target = Target()
    public var title = ""
    public var imageUrl = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        subtitle = getString(value: json["subtitle"])
        isInternal = getBool(value: json["isInternal"])
        buttonText = getString(value: json["buttonText"])
        code = getString(value: json["code"])
        id = getInt(value: json["id"])
        if let _target = json["target"] as? [String : Any]{
            target = Target.init(path: getString(value: _target["path"]))
        }
        title = getString(value: json["title"])
        imageUrl = getImageUrl(value:json["imageUrl"])
    }
    
    
    public static func banners(json : Any?) -> [Banner]{
        var list = [Banner]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Banner(obj))
            }
        }
        return list
    }
}


