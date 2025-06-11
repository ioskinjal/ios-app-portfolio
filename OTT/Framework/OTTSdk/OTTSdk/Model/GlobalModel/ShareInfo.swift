//
//  ShareInfo.swift
//  OTTSdk
//
//  Created by Chandra Sekhar on 30/08/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ShareInfo: YuppModel {
    public var shareDescription = ""
    public var imageUrl = ""
    public var isSharingAllowed = true
    public var name = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        isSharingAllowed = getBool(value:json["isSharingAllowed"])
        shareDescription = getString(value: json["description"])
        imageUrl = getImageUrl(value:json["imageUrl"])
        name = getString(value:json["name"])
    }

}
