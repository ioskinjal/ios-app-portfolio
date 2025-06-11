//
//  StreamKeyTerms.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 26/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class StreamKeyTerms: NSObject {
    public var header = ""
    public var termsDescription = [String]()
    public var confirmText = ""
    public var buttonText = ""

    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : Any?){
        super.init()
        guard let _json = json as? [String : Any] else {
            return
        }
        
        header = Utility.getStringValue(value: _json["header"])
        if let _desc = _json["description"] as? [String]{
            termsDescription = _desc
        }
        confirmText = Utility.getStringValue(value: _json["confirmText"])
        buttonText = Utility.getStringValue(value: _json["buttonText"])
    
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
