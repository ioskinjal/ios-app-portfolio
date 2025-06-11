//
//  SectionMetaData.swift
//  YuppTV
//
//  Created by Muzaffar on 11/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class SectionMetaData: NSObject {
    
    public var seoData = SeoData()
    public var isGenreFilterSupported = false
    public var sectionMetaDataDescription = ""
    public var bannerImageMobile = ""
    public var code = ""
    public var targetParams = TargetParams()
    public var isLangFilterSupported = false
    public var bannerImageWeb = ""
    public var title = ""
    public var sort = ""
    public var type = ""
    public var imageUrl = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        seoData = SeoData.init(withJSON: json["seoData"])
        isGenreFilterSupported = Utility.getBoolValue(value: json["isGenreFilterSupported"])
        sectionMetaDataDescription = Utility.getStringValue(value: json["description"])
        bannerImageMobile = Utility.getStringValue(value: json["bannerImageMobile"])
        code = Utility.getStringValue(value: json["code"])
        targetParams = TargetParams.init(withJSON: json["targetParams"])
        isLangFilterSupported = Utility.getBoolValue(value: json["isLangFilterSupported"])
        bannerImageWeb = Utility.getStringValue(value: json["bannerImageWeb"])
        title = Utility.getStringValue(value: json["title"])
        sort = Utility.getStringValue(value: json["sort"])
        type = Utility.getStringValue(value: json["type"])
        imageUrl = Utility.getStringValue(value: json["imageUrl"])
    }
    
    public static func getSectionList(json : [[String : Any]]) -> [SectionMetaData]{
        var list = [SectionMetaData]()
        for metaData in json {
            list.append(SectionMetaData.init(withJSON: metaData))
        }
        return list
    }
}
