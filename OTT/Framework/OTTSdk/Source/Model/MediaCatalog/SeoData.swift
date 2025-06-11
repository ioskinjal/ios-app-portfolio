//
//  SeoData.swift
//  YuppTV
//
//  Created by Muzaffar on 11/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class SeoData: NSObject {
    
    public var title = ""
    public var seoDatadescription = ""
    public var subject = ""
    public var tags = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        title = Utility.getStringValue(value: jsonObj["title"])
        seoDatadescription = Utility.getStringValue(value: jsonObj["description"])
        subject = Utility.getStringValue(value: jsonObj["subject"])
        tags = Utility.getStringValue(value: jsonObj["tags"])
    }
}
