//
//  Trailer.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Trailer: NSObject {
    
    public var iconUrl = ""
    public var streamUrl = ""
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        iconUrl = Utility.getStringValue(value: json["iconUrl"])
        streamUrl = Utility.getStringValue(value: json["streamUrl"])
    }
    
    public static func trailers(withJSON json: Any?) -> [Trailer]{
        var list = [Trailer]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Trailer.init(withJSON: obj))
            }
        }
        return list
    }
}
