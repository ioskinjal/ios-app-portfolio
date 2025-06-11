//
//  ResourceFile.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ResourceProfile: YuppModel {

    public var code = ""
    public var isDefault = true
    public var urlPrefix  = ""
    
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        code = getString(value: json["code"])
        isDefault = getBool(value: json["isDefault"])
        urlPrefix = getString(value: json["urlPrefix"])
    }
    
    public static func resourceProfiles(json : Any?) -> [ResourceProfile]{
        var list = [ResourceProfile]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(ResourceProfile(obj))
            }
        }
        return list
    }
}
