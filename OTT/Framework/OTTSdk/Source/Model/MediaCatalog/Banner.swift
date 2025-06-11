//
//  Banner.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 16/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Banner: NSObject {

    public var aspectHeight = 0
    public var sourceType = ""
    public var targetSubType = ""
    public var aspectWidth = 0
    public var sourceSubType = ""
    public var buttonText = ""
    public var targetParams = TargetParams()
    public var bannerId = 0
    public var subTitle = ""
    public var imageUrlWeb = ""
    public var title = ""
    public var imageUrlMobile = ""
    public var targetType = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
        aspectHeight = Utility.getIntValue(value: jsonObj["aspectHeight"])
        sourceType = Utility.getStringValue(value: jsonObj["sourceType"])
        targetSubType = Utility.getStringValue(value: jsonObj["targetSubType"])
        aspectWidth = Utility.getIntValue(value: jsonObj["aspectWidth"])
        sourceSubType = Utility.getStringValue(value: jsonObj["sourceSubType"])
        buttonText = Utility.getStringValue(value: jsonObj["buttonText"])
        if let target = jsonObj["targetParams"] as? [String : Any]{
            targetParams = TargetParams.init(withJSON: target)
        }
        bannerId = Utility.getIntValue(value: jsonObj["id"])
        subTitle = Utility.getStringValue(value: jsonObj["subTitle"])
        imageUrlWeb = Utility.getStringValue(value: jsonObj["imageUrlWeb"])
        title = Utility.getStringValue(value: jsonObj["title"])
        imageUrlMobile = Utility.getStringValue(value: jsonObj["imageUrlMobile"])
        targetType = Utility.getStringValue(value: jsonObj["targetType"])
    }
    
    public static func getBannersList(json : [[String : Any]]) -> [Banner]{
        var list = [Banner]()
        for banner in json {
            list.append(Banner.init(withJSON: banner))
        }
        return list
    }
}
