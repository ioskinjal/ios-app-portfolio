//
//  LicenseKey.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 31/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class LicenseKey: NSObject {
    public var certificate = ""
    public var license = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        guard let _json = json as? [String : Any] else {
            return
        }
        certificate = Utility.getStringValue(value: _json["certificate"])
        license = Utility.getStringValue(value: _json["license"])
    }
    
}
