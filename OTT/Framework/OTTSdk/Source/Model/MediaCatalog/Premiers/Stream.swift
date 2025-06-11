//
//  Stream.swift
//  YuppTV
//
//  Created by Muzaffar on 15/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Stream: NSObject {
    
    public var sType = ""
    public var url = ""
    public var licenseKeys = LicenseKey()
    public var isDefault = false
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        guard let _json = json as? [String : Any] else {
            return
        }
        sType = Utility.getStringValue(value: _json["sType"])
        url = Utility.getStringValue(value: _json["url"])
        licenseKeys = LicenseKey.init(withJSON: _json["licenseKeys"])
        isDefault = Utility.getBoolValue(value: _json["isDefault"])
        
    }
    
    public static func streamList(json : [[String : Any]]) -> [Stream]{
        var list = [Stream]()
        for obj in json {
            list.append(Stream.init(withJSON: obj))
        }
        return list
    }
}
