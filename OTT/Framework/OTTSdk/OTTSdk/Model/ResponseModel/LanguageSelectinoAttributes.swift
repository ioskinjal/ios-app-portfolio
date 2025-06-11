//
//  LanguageSelectinoAttributes.swift
//  OTTSdk
//
//  Created by Chandra Sekhar on 24/10/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class LanguageSelectinoAttributes: YuppModel {
    public var forceSelection = false
    public var isMultiSelectable = false
    public var isEmailVerified = false
    public var maxSelectable = false
    public var minSelectable = false
    
    internal override init() {
        super.init()
    }

    public init(_ json : [String : Any]){
        if let _forceSelection = json["forceSelection"] as? Bool{
            forceSelection = _forceSelection
        }
        if let _isMultiSelectable = json["isMultiSelectable"] as? Bool{
            isMultiSelectable = _isMultiSelectable
        }
        if let _isEmailVerified = json["isEmailVerified"] as? Bool{
            isEmailVerified = _isEmailVerified
        }
        if let _maxSelectable = json["maxSelectable"] as? Bool{
            maxSelectable = _maxSelectable
        }
        if let _minSelectable = json["minSelectable"] as? Bool{
            minSelectable = _minSelectable
        }
    }
}
