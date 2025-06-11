//
//  CastCrew.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 16/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class CastCrew: NSObject {
    public var cast = [String]()
    public var producer = ""
    public var director = ""
    public var studio = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        if let _cast = jsonObj["cast"] as? [String]{
            cast = _cast
        }
        producer = Utility.getStringValue(value: jsonObj["producer"])
        director = Utility.getStringValue(value: jsonObj["director"])
        studio = Utility.getStringValue(value: jsonObj["studio"])
        
    }
}
